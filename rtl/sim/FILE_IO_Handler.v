`timescale 1ns / 1ns

module	FILE_IO_Handler	
	#(
	parameter	per_file_width	=	10,
	parameter	handler_id		=	0)(
	
	//	List	of	input	ports
	input					clk,
	input					cs,
	input			[31:0]	MEM_Add,
	input					MEM_wen,
	input			[15:0]	MEM_Din,
	output	reg		[15:0]	MEM_Dout);

	
	reg		[15:0]		mem	[2**per_file_width-1:0];
	reg		[50*8-1:0]	file_name = "DRAM_DATAS/DRAM_DATA_dummy.txt";
	wire	[31:0]		this_file;
	reg		[31:0]		prev_file = -1;
	integer				log_fid;
	integer				chk_fid;
	integer				err_fid;
	reg					wrote_on_this = 1'b0;
	
	assign	this_file	= MEM_Add[31: per_file_width];
	
	always @(posedge clk)
	begin
		#1;
		if(MEM_wen)
		begin
			wrote_on_this						<=	1'b1;
			mem[MEM_Add[per_file_width-1:0]]	<=	MEM_Din;
		end
	end 
	
	
	always @(MEM_Add, cs)
	begin
		#1;
		MEM_Dout	<=	mem[MEM_Add[per_file_width-1:0]];
	end 
	
	
	always @(this_file, cs)
	begin
		if (cs == 1'b1)
		begin
			if(prev_file != this_file)
			begin
				if(wrote_on_this == 1'b1) 
					$writememb	(file_name, mem);
				$sformat	(file_name, "DRAM_DATAS/DRAM_DATA_%1d.txt", this_file);
				log_fid	=	$fopen("FILE_IO_HANDLER_LOG.txt", "a");
				$fwrite		(log_fid, "FIOH %2d: Reading DRAM_DATA_%1d.txt    @%0t", handler_id, this_file, $time);
				chk_fid	=	$fopen(file_name, "r");
				if			(chk_fid == 0)
				begin
					err_fid	= $fopen("ERROR_LOG.txt", "a");
					$fwrite	(log_fid, "\tIT DOES NOT EXIST\t\t\t XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
					$fwrite	(err_fid, "FIOH %2d: ERROR Reading DRAM_DATA_%1d.txt    @%0t\n", handler_id, this_file, $time);
					$fclose		(err_fid);
				end
				$fwrite	(log_fid, "\n");
				$readmemb	(file_name, mem);
				prev_file	=	this_file;
				wrote_on_this = 1'b0;
				$fclose		(chk_fid);
				$fclose		(log_fid);
			end 
		end
	end
	
	
endmodule
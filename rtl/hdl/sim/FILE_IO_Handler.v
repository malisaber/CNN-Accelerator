`timescale 1ns / 1ns
`include "hdl/packages/defines.vh"

module	FILE_IO_Handler	
	#(
	parameter	per_file_width	=	10,
	parameter	handler_id		=	0)(
	
	//	List	of	input	ports
	input					clk,
	input					cs,
	input					MEM_READ_OP,
	input					MEM_WRITE_OP,
	input			[31:0]	MEM_Add,
	input					MEM_wen,
	input			[15:0]	MEM_Din,
	output	reg		[15:0]	MEM_Dout);

	
	reg		[15:0]		mem	[2**per_file_width-1:0];
	reg		[50*8-1:0]	file_name = "";
	wire	[31:0]		this_file;
	reg		[31:0]		prev_file = -1;
	integer				log_fid;
	integer				chk_fid;
	integer				err_fid;
	reg					wrote_on_this = 1'b0;
	integer				i;
	
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
	
	initial 
	begin
		log_fid	= $fopen("report/FILE_IO_HANDLER_LOG.txt", "w");
		err_fid	= $fopen("report/ERROR_LOG.txt", "w");
		$fclose(log_fid);
		$fclose(err_fid);
	end

	always @(this_file, cs)
	begin
		if (cs == 1'b1)
		begin
			if(prev_file != this_file)
			begin
				if(wrote_on_this == 1'b1) 
					$writememh	(file_name, mem);
				
				$sformat	(file_name, "%s/DRAM_DATA_%1d.txt", `DRAM_DATA_DIR, this_file);
				log_fid	=	$fopen("report/FILE_IO_HANDLER_LOG.txt", "a");
				chk_fid	=	$fopen(file_name, "r");

				if (MEM_READ_OP == 1'b1)
					$fwrite	(log_fid, "FIOH %3d, @%12t: (R) Reading DRAM_DATA_%1d.txt    ", handler_id, $time, this_file);
				else if (MEM_WRITE_OP == 1'b1)
					$fwrite	(log_fid, "FIOH %3d, @%12t: (W) Reading DRAM_DATA_%1d.txt    ", handler_id, $time, this_file);
				else
					$fwrite	(log_fid, "FIOH %3d, @%12t: (X) Reading DRAM_DATA_%1d.txt    ", handler_id, $time, this_file);
				
				
				if			(chk_fid == 0)
				begin
					err_fid	= $fopen("report/ERROR_LOG.txt", "a");
					if (MEM_READ_OP == 1'b1)
					begin
						$fwrite	(log_fid, "\tIT DOES NOT EXIST\t\t\t XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
						$fwrite	(err_fid, "FIOH %3d, @%12t: ERROR Reading DRAM_DATA_%1d.txt    @%0t\n", handler_id, $time, this_file);
					end
					if (MEM_WRITE_OP == 1'b1)
						$fwrite	(log_fid, "\tEmpty File.");
					$fclose		(err_fid);
				end
				$fwrite	(log_fid, "\n");

				if			(chk_fid == 0)
					for (i=0; i<2**per_file_width-1; i=i+1)
						mem	[i] = 16'hDEAD;
				else
					$readmemh(file_name, mem);
				
				prev_file	=	this_file;
				wrote_on_this = 1'b0;
				$fclose		(chk_fid);
				$fclose		(log_fid);
			end 
		end
	end
	
	
endmodule
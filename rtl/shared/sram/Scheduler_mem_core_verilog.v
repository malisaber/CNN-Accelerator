`timescale 1ns / 1ns
`include "packages/defines.vh"


module Scheduler_mem_core_verilog	
	#(
	parameter	line_count	=	100)(
	
    // List of input ports
    input	wire			clk1,
    input	wire	[31:0]	addr1,
    input	wire	[31:0]	data_in1,
    input	wire			write_enable1,
    output	reg		[31:0]	data_out1,
    
    input	wire			clk2,
    input	wire	[31:0]	addr2,
    input	wire	[31:0]	data_in2,
    input	wire			write_enable2,
    output	reg		[31:0]	data_out2);

    
	reg		[31:0]		mem		[line_count-1:0];
	integer				file_addr;
	integer				file_data;
	reg		[31:0]		addr;
	reg		[31:0]		data;
	reg		[50*8-1:0]	addr_file_name = "";
	reg		[50*8-1:0]	data_file_name = "";
	
	initial
	begin
        // Open the file in read mode
        $sformat	(addr_file_name, "%s/Main_Mem_Addr.txt", `SCHEDULER_CODE_DIR);
		$sformat	(data_file_name, "%s/Main_Mem_Data.txt", `SCHEDULER_CODE_DIR);
        file_addr = $fopen(addr_file_name, "r");
        file_data = $fopen(data_file_name, "r");
        
        if (file_addr == 0)
		begin
            $display("Error: Could not open the address file.");
            $finish;
        end
		
        if (file_data == 0)
		begin
            $display("Error: Could not open the data file.");
            $finish;
        end

        // Read the file until end of file
        while (!$feof(file_addr) && !$feof(file_data)) begin
            // Read two integers from the file
            $fscanf(file_addr, "%b\n", addr);
            $fscanf(file_data, "%b\n", data);
			mem[addr/4] = data;
        end

        // Close the file
        $fclose(file_addr);
        $fclose(file_data);
    end
	
	
	
	
	always @(posedge clk1)
	begin
		if(write_enable1)
			mem[addr1] <= data_in1;
	end
	
	always @(posedge clk2)
	begin
		if(write_enable2)
			mem[addr2] <= data_in2;
	end
	
	always @(*)	data_out1 = mem[addr1];
	always @(*)	data_out2 = mem[addr2];
	
	
endmodule

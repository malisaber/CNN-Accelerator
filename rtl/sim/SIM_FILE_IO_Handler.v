module	SIM_FILE_IO_Handler;
	
	reg				clk;
	reg		[31:0]	MEM_Add;
	reg				MEM_wen;
	reg		[31:0]	MEM_Din;
	wire	[31:0]	MEM_Dout;
	
	
	FILE_IO_Handler#(
		.per_file_width(3))
	UUT(
		.clk(clk),
		.MEM_Add(MEM_Add),
		.MEM_wen(MEM_wen),
		.MEM_Din(MEM_Din),
		.MEM_Dout(MEM_Dout));	
	
	
	always
	begin
		clk	= 0;
		#5;
		clk	= 1;
		#5;
	end
	
	
	initial
	begin
		MEM_Add = 0;
		MEM_wen = 0;
		MEM_Din = 0;
		#100;
		repeat(10)
		begin
			MEM_wen = 1;
			#10;
			MEM_wen = 0;
			#10;
		end
	end
	
	
	always
	begin
		MEM_Add	= MEM_Add + 1;
		#10;
	end
	
	
	always
	begin
		MEM_Din	= MEM_Din + 1;
		#20;
	end
	
	
	
	
	
endmodule

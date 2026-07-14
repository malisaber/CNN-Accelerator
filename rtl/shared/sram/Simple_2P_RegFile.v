module Simple_2P_RegFile	
	#(
	parameter	Asize	=	4,
	parameter	Dsize	=	8)(
	
    // List of input ports
    input	wire				clk,
    input	wire	[Asize-1:0]	MEM_1_Add,
    input	wire	[Dsize-1:0]	MEM_1_Din,
    input	wire				MEM_1_wen,
    output	reg		[Dsize-1:0]	MEM_1_Dout,
    
    input	wire	[Asize-1:0]	MEM_2_Add,
    input	wire	[Dsize-1:0]	MEM_2_Din,
    input	wire				MEM_2_wen,
    output	reg		[Dsize-1:0]	MEM_2_Dout);

    
	reg	[Dsize-1:0]	mem	[(2**Asize)-1:0];
	
	
	always @(posedge clk)
	begin
		if(MEM_1_wen)
			mem[MEM_1_Add] <= MEM_1_Din;
	end
	
	always @(posedge clk)
	begin
		if(MEM_2_wen)
			mem[MEM_2_Add] <= MEM_2_Din;
	end
	
	always @(*)	MEM_1_Dout = mem[MEM_1_Add];
	always @(*)	MEM_2_Dout = mem[MEM_2_Add];
	
	
endmodule


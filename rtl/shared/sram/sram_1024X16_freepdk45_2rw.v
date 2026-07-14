// OpenRAM SRAM model
// Words: 256
// Word size: 16

module sram_1024X16_freepdk45_2rw
	(
	// Port 0: RW
	input			clk0,
	input			csb0,
	input			web0,
	input	[9:0]	addr0,
	input	[15:0]	din0,
	output	[15:0]	dout0,
	// Port 1: RW
	input			clk1,
	input			csb1,
	input			web1,
	input	[9:0]	addr1,
	input	[15:0]	din1,
	output	[15:0]	dout1
	);

	sram_16_1024_freepdk45		Mem_Block
	(
		// Port 0: RW
		.clk0	(clk0),
		.csb0	(csb0),
		.web0	(web0),
		.addr0	(addr0),
		.din0	(din0),
		.dout0	(dout0),
		// Port 1: RW
		.clk1	(clk1),
		.csb1	(csb1),
		.web1	(web1),
		.addr1	(addr1),
		.din1	(din1),
		.dout1	(dout1)
	);

endmodule

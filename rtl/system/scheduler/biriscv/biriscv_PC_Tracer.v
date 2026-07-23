module	biriscv_PC_Tracer(
	//	List	of	input	ports
	input			clk,
	input	[31:0]	PC);
	
	integer			track_fid;
	reg		[31:0]	old_PC;
	
	initial
	begin
		old_PC		= 32'hDEADBEEF;
		track_fid	= $fopen("report/PC_trac_log.log", "w");
		//$fclose(track_fid);
	end
	
	always @(posedge clk)
	begin
		if (PC != old_PC)
		begin
			$fwrite(track_fid, "%8h@%0t\n", PC, $time);
		end
		old_PC <= PC;
	end 
	
endmodule

module	uPROC_Port_Tracker(
	//	List	of	input	ports
	input			clk,
	input	[31:0]	uPROC_PORT_Address,
	input	[63:0]	uPROC_PORT_Data_out);
	
	integer					track_fid;
	reg		[31:0]	previous_address = 0;
	
	initial
	begin
		track_fid = $fopen("uPROC_Transaction_LOG.txt", "w");
		//$fclose(track_fid);
	end
	
	always @(posedge clk)
	begin
		if(previous_address != uPROC_PORT_Address)
		begin
			$fwrite(track_fid, "R:\tAdd:\t%8h\t\tData:%16h\t\t@%0t\n", previous_address, uPROC_PORT_Data_out, $time);
		end
		previous_address <= uPROC_PORT_Address;
	end 
	
endmodule

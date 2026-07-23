module	Main_Port_Tracker(
	//	List	of	input	ports
	input			clk,
	input	[31:0]	MAIN_PORT_Address,
	input			MAIN_PORT_WEN,
	input			MAIN_PORT_OEN,
	input	[31:0]	MAIN_PORT_Data_in,
	input	[31:0]	MAIN_PORT_Data_out);
	
	integer					track_fid;
	
	initial
	begin
		track_fid = $fopen("report/MainPort_Transaction_LOG.log", "w");
		//$fclose(track_fid);
	end
	
	always @(posedge clk)
	begin
		//track_fid = $fopen("MainPort_Transaction_LOG.log", "w");
		if(MAIN_PORT_WEN == 1'b1)
		begin
			$fwrite(track_fid, "W:\tAdd:\t%8h\t\tData:%8h\t\t@%0t\n", MAIN_PORT_Address, MAIN_PORT_Data_in, $time);
		end
		else if(MAIN_PORT_OEN == 1'b1)
		begin
			$fwrite(track_fid, "R:\tAdd:\t%8h\t\tData:%8h\t\t@%0t\n", MAIN_PORT_Address, MAIN_PORT_Data_out, $time);
		end
		//$fclose(track_fid);
	end 
	
endmodule
module	Tx_Tracker(
	//	List	of	input	ports
	input	[7:0]	Tx_SW_Data,
	input			Tx_SW_Enable,
	input			Tx_SW_send);
	
	integer					track_fid;
	
	initial 
	begin
		track_fid = $fopen("report/Tx_Tracker.log", "w");
		//$fclose(track_fid);
	end
	
	always @(Tx_SW_Data, Tx_SW_Enable, Tx_SW_send)
	begin
		if ((Tx_SW_Enable == 1'b1) && (Tx_SW_send == 1'b1))
			$fwrite	(track_fid, "%c", Tx_SW_Data);
	end 
	
endmodule
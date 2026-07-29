//-----------------------------------------------------------------
// biriscv_regfile_tracer
//
// Logs a snapshot of the biRISC-V register file (x0-x31) to a
// text log file, in the format:
//
//   @time, on_temporary, val0, val1, ..., val31
//
// - "on_temporary" is the On_Tmporary_i control signal (1 when
//   the hardware content-switching temporary bank is selected).
// - Each val is printed as an 8-digit (32-bit) hex number.
//
// A line is only written when something actually changes:
//   - a register write is issued (rd0_i != 0 or rd1_i != 0), or
//   - On_Tmporary_i toggles (switching into/out of the temporary
//     bank), which changes the register view even with no write.
//
// Non-intrusive: it does NOT touch biriscv_regfile.v. Instead it
// taps the same write-back ports that feed u_regfile inside
// biriscv_issue.v (rd0_i/rd0_value_i, rd1_i/rd1_value_i) plus the
// On_Tmporary_i / Clear_Tmporary_i control signals, and mirrors
// the exact bank-switching behaviour of biriscv_regfile.v in a
// local shadow copy of both the main bank and the temporary bank.
//-----------------------------------------------------------------
module biriscv_regfile_tracer
(
    // List of input ports
     input           clk
    ,input           rst
    ,input           On_Tmporary_i
    ,input           Clear_Tmporary_i
    ,input  [  4:0]  rd0_i
    ,input  [ 31:0]  rd0_value_i
    ,input  [  4:0]  rd1_i
    ,input  [ 31:0]  rd1_value_i
);

integer         track_fid;
integer         i;

// Persistent shadow copies of both banks
reg     [31:0]  main_bank_q [31:0];
reg     [31:0]  temp_bank_q [31:0];

// Working copies computed (with blocking assignments) each cycle
// so the log line reflects the values that become valid on this
// same clock edge, then committed into the *_q arrays above.
reg     [31:0]  main_bank_r [31:0];
reg     [31:0]  temp_bank_r [31:0];

// Tracks On_Tmporary_i from the previous cycle, so a bank switch
// (with no accompanying write) is still detected and logged.
reg             on_temporary_q;

//-----------------------------------------------------------------
// Registers that biriscv_regfile.v swaps between the main and
// temporary bank when On_Tmporary_i is set. x0 (zero), x2 (sp),
// x8/x9 (s0/s1) and x18-x27 (s2-s11) are NEVER swapped.
//-----------------------------------------------------------------
function is_swappable;
    input [4:0] r;
begin
    is_swappable = !(r == 5'd0 || r == 5'd2 || r == 5'd8 || r == 5'd9 ||
                     (r >= 5'd18 && r <= 5'd27));
end
endfunction

initial
begin
    track_fid = $fopen("report/RegFile_Snapshot_log.log", "w");
    for (i = 0; i < 32; i = i + 1)
    begin
        main_bank_q[i] = 32'h00000000;
        temp_bank_q[i] = 32'h00000000;
    end
    on_temporary_q = 1'b0;
end

wire write_event_w  = (rd0_i != 5'd0) || (rd1_i != 5'd0);
wire switch_event_w = (On_Tmporary_i != on_temporary_q);
wire log_event_w    = write_event_w || switch_event_w;

always @ (posedge clk)
begin
    if (rst)
    begin
        for (i = 0; i < 32; i = i + 1)
        begin
            main_bank_r[i] = 32'h00000000;
            temp_bank_r[i] = 32'h00000000;
        end
    end
    else
    begin
        // Start from the current shadow state
        for (i = 0; i < 32; i = i + 1)
        begin
            main_bank_r[i] = main_bank_q[i];
            temp_bank_r[i] = temp_bank_q[i];
        end

        // Clear_Tmporary_i wipes the temporary bank, same as
        // biriscv_regfile.v. A write below in the same cycle to
        // the same register still overrides this, matching the
        // real hardware's statement ordering.
        if (Clear_Tmporary_i)
        begin
            for (i = 0; i < 32; i = i + 1)
                if (is_swappable(i))
                    temp_bank_r[i] = 32'h00000000;
        end

        // Write port 0 (priority over port 1 when both target the
        // same register, matching biriscv_regfile.v)
        if (rd0_i != 5'd0)
        begin
            if (is_swappable(rd0_i) && On_Tmporary_i)
                temp_bank_r[rd0_i] = rd0_value_i;
            else
                main_bank_r[rd0_i] = rd0_value_i;
        end

        // Write port 1
        if ((rd1_i != 5'd0) && (rd1_i != rd0_i))
        begin
            if (is_swappable(rd1_i) && On_Tmporary_i)
                temp_bank_r[rd1_i] = rd1_value_i;
            else
                main_bank_r[rd1_i] = rd1_value_i;
        end

        // Only log when a write is issued, or the temporary bank
        // is switched in/out.
        if (log_event_w)
        begin
            $fwrite(track_fid, "@%0t, %0d", $time, On_Tmporary_i);
            for (i = 0; i < 32; i = i + 1)
            begin
                if (is_swappable(i) && On_Tmporary_i)
                    $fwrite(track_fid, ", %08h", temp_bank_r[i]);
                else
                    $fwrite(track_fid, ", %08h", main_bank_r[i]);
            end
            $fwrite(track_fid, "\n");
        end
    end

    // Commit working copies into the persistent shadow state
    for (i = 0; i < 32; i = i + 1)
    begin
        main_bank_q[i] <= main_bank_r[i];
        temp_bank_q[i] <= temp_bank_r[i];
    end

    on_temporary_q <= On_Tmporary_i;
end

endmodule
//-----------------------------------------------------------------
// biriscv_pc_tracer2.v
//
// Retirement-accurate PC / instruction tracer for biRISC-V.
//
// WHY THIS EXISTS
// ----------------
// The original biriscv_PC_Tracer was wired to `fetch0_pc_w`, which is
// a signal in the *frontend*, i.e. before issue, before branch
// resolution, before pipeline-flush handling. Because biRISC-V has
// branch prediction (BTB/BHT/RAS/GSHARE) and is a 2-wide in-order
// issue machine, that signal contains a lot of speculative, wrong
// path PCs that are later squashed:
//   - predicted-but-mispredicted branches/returns
//   - PCs fetched during the shadow of a flush (exception, eret,
//     fence, satp write, branch misprediction)
// A trace built from that point can never be turned into a correct
// call stack, because it literally contains instructions that never
// executed.
//
// This module instead taps the *writeback / commit* point of each
// execution pipe (pipe0_valid_wb / pipe1_valid_wb from
// biriscv_issue), which is only asserted for instructions that have
// survived all flush/squash checks - i.e. it is program-order,
// architecturally-committed PCs only. It additionally reports
// exception/interrupt-taken events explicitly (cause + PC) instead
// of making the offline tool guess from symbol names.
//
// LOG FORMAT
// ----------
// Two kinds of lines are written, distinguished by a leading tag
// character so the post-processor doesn't need to guess:
//
//   I <8-hex PC>@<time> <8-hex opcode>
//       A normal committed instruction. pipe0 is always logged
//       before pipe1 in the same cycle (in-order commit).
//
//   X <8-hex PC>@<time> <2-hex cause>
//       A genuine exception/interrupt was TAKEN this cycle (cause
//       < 6'h30, i.e. misaligned/illegal/ecall/page-fault/interrupt -
//       see EXCEPTION_* in biriscv_defs.v). PC is the PC associated
//       with the event (interrupted PC for interrupts, faulting PC
//       for synchronous exceptions).
//
//       IMPORTANT: mret/sret/uret (EXCEPTION_ERET_* = 6'h30..6'h33)
//       and fence/sfence/satp writes (EXCEPTION_FENCE = 6'h34) also
//       drive csr_writeback_exception_o nonzero, but that's just how
//       the CSR unit requests a pipeline flush for an instruction
//       that already committed a perfectly normal 'I' record (an
//       eret opcode, decodable on its own). They are deliberately
//       NOT logged as 'X' here - doing so would tell the offline
//       tool "a new trap was just taken" a second time for the same
//       return instruction, which corrupts call-stack reconstruction
//       (every instruction after the return gets mislabeled as still
//       being inside the interrupt).
//-----------------------------------------------------------------
module biriscv_pc_tracer2
(
    input           clk_i,
    input           rst_i,

    // Pipe0 commit (writeback stage of biriscv_issue)
    input           pipe0_valid_i,
    input  [31:0]   pipe0_pc_i,
    input  [31:0]   pipe0_opcode_i,

    // Pipe1 commit (writeback stage of biriscv_issue)
    input           pipe1_valid_i,
    input  [31:0]   pipe1_pc_i,
    input  [31:0]   pipe1_opcode_i,

    // Exception / interrupt taken this cycle (6'b0 == none)
    input  [5:0]    exception_i,
    input  [31:0]   exception_pc_i
);

integer track_fid;

initial
begin
    track_fid = $fopen("report/PC_trac_log.log", "w");
end

always @ (posedge clk_i)
begin
    if (!rst_i)
    begin
        if (pipe0_valid_i)
            $fwrite(track_fid, "I %8h@%0t %8h\n", pipe0_pc_i, $time, pipe0_opcode_i);

        if (pipe1_valid_i)
            $fwrite(track_fid, "I %8h@%0t %8h\n", pipe1_pc_i, $time, pipe1_opcode_i);

        if (|exception_i && (exception_i < 6'h30))
            $fwrite(track_fid, "X %8h@%0t %2h\n", exception_pc_i, $time, exception_i);
    end
end

endmodule

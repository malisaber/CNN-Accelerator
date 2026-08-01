#ifndef HAL_SERIAL_H
#define HAL_SERIAL_H

#include <cstdint>
#include <cstddef>
#include "common.h"
#include "MiniString.h"

// ---------------------------------------------------------------------------
// hal_serial
//
// Hardware Abstraction Layer for the memory-mapped serial transceiver
// block (TRx_Box.vhd: TRx + TX_Fifo + RX_Fifo).
//
// Registers and bit positions are NOT redefined here - they are pulled
// straight from common.h, which is the single source of truth for the
// peripheral address map:
//
//   C_PERIPHERAL_REG_TRx_UNIT_DATA_WORD   (base + C_TRxU_Address_Excess_val + 0x00)
//   C_PERIPHERAL_REG_TRx_UNIT_CONT_WORD   (base + C_TRxU_Address_Excess_val + 0x04)
//
//   DATA word:
//     write : bits[C_TRx_Unit_DATA_0_pos .. +7]       TX data byte
//     read  : bit [C_TRx_Unit_Rx_DORE_Flg_pos]        DORE flag
//             bits[C_TRx_Unit_DATA_0_pos .. +7]       RX data byte
//
//   CONT (control/status) word:
//     write : bit [C_TRx_Unit_Tx_Enable_pos]                 Tx enable
//             bit [C_TRx_Unit_Rx_Enable_pos]                 Rx enable
//             bit [C_TRx_Unit_Tx_Buff_Empty_Intr_en_pos]     Tx-buffer-empty IRQ enable
//             bit [C_TRx_Unit_Rx_Buff_Full_Intr_en_pos]      Rx-buffer-full  IRQ enable
//             bit [C_TRx_Unit_Tx_Data_Sent_Intr_en_pos]      Tx-done         IRQ enable
//             bit [C_TRx_Unit_Rx_Data_Received_Intr_en_pos]  Rx-done         IRQ enable
//             bit [C_TRx_Unit_Interrupt_clear_pos]           Interrupt clear (strobe)
//             bits[C_TRx_Unit_Clk_Div_pos .. +3]             Clock divider (4 bits)
//             bits[C_TRx_Unit_Top_pos .. +C_TRx_Unit_Top_len-1] TOP value (16 bits)
//     read  : bit [C_TRx_Unit_Tx_Buff_Empty_Flg_pos]         TBE flag
//             bit [C_TRx_Unit_Tx_Buff_Full_Flg_pos]          TBF flag
//             bit [C_TRx_Unit_Rx_Buff_Empty_Flg_pos]         RBE flag
//             bit [C_TRx_Unit_Rx_Buff_Full_Flg_pos]          RBF flag
//
// Note: common.h also defines C_TRx_Unit_DATA_1_pos / _2_pos / _3_pos
// (bit offsets 8/16/24) alongside C_TRx_Unit_DATA_0_pos (offset 0), as if
// up to 4 bytes could be packed into one DATA-word access. The TRx_Box
// VHDL this HAL targets only implements a single byte per DATA-word
// access (bits [7:0] on write, bits [7:0] + DORE on read) - so only
// C_TRx_Unit_DATA_0_pos is used below. If your hardware's DATA word
// really does pack up to 4 bytes per access, this HAL will need a
// widened writeByte()/readByte() to match - flag this if so.
//
// This layer does register-level I/O only. All values that touch a
// register - the register word itself, the data byte, status flags,
// spin counters - are kept as uint32_t (unsigned int), because the
// target only supports 32-bit-wide memory accesses; no 8/16-bit
// register-facing types are used anywhere in this file or hal_serial.cpp.
// MiniString is used purely as an in-memory (non-register) string buffer
// for the convenience helpers, so it keeps its normal 8-bit char storage.
// ---------------------------------------------------------------------------

namespace hal_serial
{

// Baud configuration ----------------------------------------------------------
struct BaudConfig
{
    uint32_t clk_div; // 4-bit clock divider, 0-15 (upper bits ignored)
    uint32_t top;     // 16-bit period/top count (upper bits ignored)
};

// Result codes for blocking-with-timeout style calls ---------------------------
enum class Status : uint32_t
{
    Ok = 0,
    Timeout,
    BufferFull,
    BufferEmpty
};

// -----------------------------------------------------------------------------
// SerialPort
//
// Wraps the single TRx_Unit register pair exposed by common.h
// (C_PERIPHERAL_REG_TRx_UNIT_DATA_WORD / _CONT_WORD). There is one such
// peripheral instance on this system, so the pointers are fixed; the
// constructor lets you override them (e.g. for host-side unit testing)
// but defaults to the real hardware addresses.
// -----------------------------------------------------------------------------
class SerialPort
{
public:
    explicit SerialPort(volatile unsigned int* data_reg = C_PERIPHERAL_REG_TRx_UNIT_DATA_WORD,
                         volatile unsigned int* cont_reg = C_PERIPHERAL_REG_TRx_UNIT_CONT_WORD);

    // -- setup --------------------------------------------------------------
    // enable_tx / enable_rx: 0 = disabled, non-zero = enabled.
    void init(const BaudConfig& baud, uint32_t enable_tx = 1, uint32_t enable_rx = 1);
    void setBaud(const BaudConfig& baud);
    void enableTx(uint32_t en);
    void enableRx(uint32_t en);

    // -- interrupts -----------------------------------------------------------
    // Each flag: 0 = disabled, non-zero = enabled.
    void enableInterrupts(uint32_t tx_empty, uint32_t rx_full, uint32_t tx_done, uint32_t rx_done);
    void clearInterrupts();

    // -- status ---------------------------------------------------------------
    // Each returns 0 (flag clear) or 1 (flag set).
    uint32_t txBufferEmpty() const;
    uint32_t txBufferFull()  const;
    uint32_t rxBufferEmpty() const;
    uint32_t rxBufferFull()  const;

    // -- word-level (32-bit) I/O -------------------------------------------------
    // Non-blocking. `b` carries the data byte in its low 8 bits (upper bits
    // ignored on write). Returns Status::BufferFull if the Tx FIFO can't
    // accept it right now.
    Status writeByte(uint32_t b);

    // Non-blocking. `out` receives the data byte in its low 8 bits.
    // Returns Status::BufferEmpty if no byte is available.
    // `dore` (if non-null) receives the DORE status bit from the read.
    Status readByte(uint32_t& out, uint32_t* dore = nullptr);

    // Blocking versions with a simple spin-count timeout (0 = wait forever).
    Status writeByteBlocking(uint32_t b, uint32_t max_spins = 0);
    Status readByteBlocking(uint32_t& out, uint32_t max_spins = 0, uint32_t* dore = nullptr);

    // -- string-level convenience helpers ----------------------------------------
    // Blocking write of a whole buffer/C-string. Stops early (returns
    // Status::Timeout) if max_spins_per_byte is exhausted on any byte.
    Status writeString(const char* s, uint32_t max_spins_per_byte = 0);

    template <std::size_t N>
    Status writeString(const MiniString<N>& s, uint32_t max_spins_per_byte = 0)
    {
        return writeString(s.c_str(), max_spins_per_byte);
    }

    // Reads bytes into `out` until the Rx FIFO is empty or `out` is full.
    // Non-blocking: drains whatever is currently available.
    // Returns the number of bytes read.
    template <std::size_t N>
    std::size_t readAvailable(MiniString<N>& out)
    {
        std::size_t count = 0;
        uint32_t b;
        while (!out.full() && readByte(b) == Status::Ok)
        {
            out.push_back(static_cast<char>(b & 0xFFu));
            ++count;
        }
        return count;
    }

    // Blocking read of a line terminated by `terminator` (default '\n'),
    // or until `out` is full. The terminator itself is not stored.
    template <std::size_t N>
    Status readLineBlocking(MiniString<N>& out, char terminator = '\n', uint32_t max_spins = 0)
    {
        out.clear();
        while (!out.full())
        {
            uint32_t b;
            Status st = readByteBlocking(b, max_spins);
            if (st != Status::Ok) return st;
            char c = static_cast<char>(b & 0xFFu);
            if (c == terminator) return Status::Ok;
            out.push_back(c);
        }
        return Status::Ok; // filled the buffer without seeing the terminator
    }

private:
    volatile unsigned int* dataReg_;
    volatile unsigned int* ctrlReg_;

    // Shadow of the fields *we* write to the control word, so a partial
    // update (e.g. enableTx) doesn't clobber clk_div/top/enables that
    // were set earlier - the control word is not simply read-modify-write
    // safe because read-side and write-side bit groupings differ.
    uint32_t ctrlShadow_;

    uint32_t readCtrl() const;
    void     writeCtrl(uint32_t value);
};

} // namespace hal_serial

#endif // HAL_SERIAL_H
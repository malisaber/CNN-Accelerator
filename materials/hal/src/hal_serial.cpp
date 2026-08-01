#include "hal_serial.h"

namespace hal_serial
{

namespace
{
    inline uint32_t bit(uint32_t pos) { return 1u << pos; }

    constexpr uint32_t DATA_BYTE_MASK = 0xFFu; // 8 bits at C_TRx_Unit_DATA_0_pos
    constexpr uint32_t CLK_DIV_MASK   = 0xFu << C_TRx_Unit_Clk_Div_pos;
    constexpr uint32_t TOP_MASK       = ((1u << C_TRx_Unit_Top_len) - 1u) << C_TRx_Unit_Top_pos;
}

SerialPort::SerialPort(volatile unsigned int* data_reg, volatile unsigned int* cont_reg)
    : dataReg_(data_reg)
    , ctrlReg_(cont_reg)
    , ctrlShadow_(0)
{
}

// ---------------------------------------------------------------------------
// Setup
// ---------------------------------------------------------------------------

void SerialPort::init(const BaudConfig& baud, uint32_t enable_tx, uint32_t enable_rx)
{
    ctrlShadow_ = 0;

    if (enable_tx) ctrlShadow_ |= bit(C_TRx_Unit_Tx_Enable_pos);
    if (enable_rx) ctrlShadow_ |= bit(C_TRx_Unit_Rx_Enable_pos);

    ctrlShadow_ &= ~CLK_DIV_MASK;
    ctrlShadow_ |= (baud.clk_div << C_TRx_Unit_Clk_Div_pos) & CLK_DIV_MASK;

    ctrlShadow_ &= ~TOP_MASK;
    ctrlShadow_ |= (baud.top << C_TRx_Unit_Top_pos) & TOP_MASK;

    writeCtrl(ctrlShadow_);
}

void SerialPort::setBaud(const BaudConfig& baud)
{
    ctrlShadow_ &= ~CLK_DIV_MASK;
    ctrlShadow_ |= (baud.clk_div << C_TRx_Unit_Clk_Div_pos) & CLK_DIV_MASK;

    ctrlShadow_ &= ~TOP_MASK;
    ctrlShadow_ |= (baud.top << C_TRx_Unit_Top_pos) & TOP_MASK;

    writeCtrl(ctrlShadow_);
}

void SerialPort::enableTx(uint32_t en)
{
    if (en) ctrlShadow_ |=  bit(C_TRx_Unit_Tx_Enable_pos);
    else    ctrlShadow_ &= ~bit(C_TRx_Unit_Tx_Enable_pos);
    writeCtrl(ctrlShadow_);
}

void SerialPort::enableRx(uint32_t en)
{
    if (en) ctrlShadow_ |=  bit(C_TRx_Unit_Rx_Enable_pos);
    else    ctrlShadow_ &= ~bit(C_TRx_Unit_Rx_Enable_pos);
    writeCtrl(ctrlShadow_);
}

// ---------------------------------------------------------------------------
// Interrupts
// ---------------------------------------------------------------------------

void SerialPort::enableInterrupts(uint32_t tx_empty, uint32_t rx_full, uint32_t tx_done, uint32_t rx_done)
{
    auto setBit = [this](uint32_t pos, uint32_t en)
    {
        if (en) ctrlShadow_ |=  bit(pos);
        else    ctrlShadow_ &= ~bit(pos);
    };

    setBit(C_TRx_Unit_Tx_Buff_Empty_Intr_en_pos,    tx_empty);
    setBit(C_TRx_Unit_Rx_Buff_Full_Intr_en_pos,     rx_full);
    setBit(C_TRx_Unit_Tx_Data_Sent_Intr_en_pos,     tx_done);
    setBit(C_TRx_Unit_Rx_Data_Received_Intr_en_pos, rx_done);

    writeCtrl(ctrlShadow_);
}

void SerialPort::clearInterrupts()
{
    // Interrupt_clear is a strobe: pulse it high on top of the current
    // shadow, then drop it back so the shadow doesn't hold it asserted.
    writeCtrl(ctrlShadow_ | bit(C_TRx_Unit_Interrupt_clear_pos));
    writeCtrl(ctrlShadow_);
}

// ---------------------------------------------------------------------------
// Status
// ---------------------------------------------------------------------------

uint32_t SerialPort::txBufferEmpty() const
{
    return (readCtrl() & bit(C_TRx_Unit_Tx_Buff_Empty_Flg_pos)) != 0 ? 1u : 0u;
}

uint32_t SerialPort::txBufferFull() const
{
    return (readCtrl() & bit(C_TRx_Unit_Tx_Buff_Full_Flg_pos)) != 0 ? 1u : 0u;
}

uint32_t SerialPort::rxBufferEmpty() const
{
    return (readCtrl() & bit(C_TRx_Unit_Rx_Buff_Empty_Flg_pos)) != 0 ? 1u : 0u;
}

uint32_t SerialPort::rxBufferFull() const
{
    return (readCtrl() & bit(C_TRx_Unit_Rx_Buff_Full_Flg_pos)) != 0 ? 1u : 0u;
}

// ---------------------------------------------------------------------------
// Word-level (32-bit) I/O
// ---------------------------------------------------------------------------

Status SerialPort::writeByte(uint32_t b)
{
    if (txBufferFull()) return Status::BufferFull;
    *dataReg_ = (b << C_TRx_Unit_DATA_0_pos) & DATA_BYTE_MASK;
    return Status::Ok;
}

Status SerialPort::readByte(uint32_t& out, uint32_t* dore)
{
    if (rxBufferEmpty()) return Status::BufferEmpty;
    uint32_t word = *dataReg_;
    out = (word >> C_TRx_Unit_DATA_0_pos) & DATA_BYTE_MASK;
    if (dore) *dore = (word >> C_TRx_Unit_Rx_DORE_Flg_pos) & 0x1u;
    return Status::Ok;
}

Status SerialPort::writeByteBlocking(uint32_t b, uint32_t max_spins)
{
    uint32_t spins = 0;
    while (txBufferFull())
    {
        if (max_spins != 0 && ++spins >= max_spins) return Status::Timeout;
    }
    *dataReg_ = (b << C_TRx_Unit_DATA_0_pos) & DATA_BYTE_MASK;
    return Status::Ok;
}

Status SerialPort::readByteBlocking(uint32_t& out, uint32_t max_spins, uint32_t* dore)
{
    uint32_t spins = 0;
    while (rxBufferEmpty())
    {
        if (max_spins != 0 && ++spins >= max_spins) return Status::Timeout;
    }
    uint32_t word = *dataReg_;
    out = (word >> C_TRx_Unit_DATA_0_pos) & DATA_BYTE_MASK;
    if (dore) *dore = (word >> C_TRx_Unit_Rx_DORE_Flg_pos) & 0x1u;
    return Status::Ok;
}

// ---------------------------------------------------------------------------
// String-level helpers
// ---------------------------------------------------------------------------

Status SerialPort::writeString(const char* s, uint32_t max_spins_per_byte)
{
    if (!s) return Status::Ok;
    while (*s != '\0')
    {
        Status st = writeByteBlocking(static_cast<uint32_t>(static_cast<unsigned char>(*s)), max_spins_per_byte);
        if (st != Status::Ok) return st;
        ++s;
    }
    return Status::Ok;
}

// ---------------------------------------------------------------------------
// Internals
// ---------------------------------------------------------------------------

uint32_t SerialPort::readCtrl() const
{
    return *ctrlReg_;
}

void SerialPort::writeCtrl(uint32_t value)
{
    *ctrlReg_ = value;
}

} // namespace hal_serial
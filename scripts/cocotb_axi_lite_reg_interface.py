# test_axi_lite_reg_interface.py

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer
from cocotb.result import TestFailure


REG_WIDTH = 32


async def reset_dut(dut):
    dut.ARESETn <= 0
    for _ in range(2):
        await RisingEdge(dut.ACLK)
    dut.ARESETn <= 1
    await RisingEdge(dut.ACLK)


async def write_reg(dut, address, data, strb=None, delay_write=0, delay_bready=0):
    if strb is None:
        strb = (2**(REG_WIDTH // 8)) - 1

    dut.AWADDR <= address
    dut.WDATA <= data
    dut.WSTRB <= strb
    dut.AWVALID <= 1
    dut.WVALID <= 0
    dut.BREADY <= 0

    await RisingEdge(dut.ACLK)
    while not dut.AWREADY.value:
        await RisingEdge(dut.ACLK)
    dut.AWVALID <= 0

    for _ in range(delay_write):
        await RisingEdge(dut.ACLK)

    dut.WVALID <= 1
    while not dut.WREADY.value:
        await RisingEdge(dut.ACLK)
    dut.WVALID <= 0

    for _ in range(delay_bready):
        await RisingEdge(dut.ACLK)

    dut.BREADY <= 1
    while not dut.BVALID.value:
        await RisingEdge(dut.ACLK)
    bresp = int(dut.BRESP.value)
    dut.BREADY <= 0
    return bresp


async def read_reg(dut, address, delay_rready=0):
    dut.ARADDR <= address
    dut.ARVALID <= 1
    dut.RREADY <= 0

    await RisingEdge(dut.ACLK)
    while not dut.ARREADY.value:
        await RisingEdge(dut.ACLK)
    dut.ARVALID <= 0

    while not dut.RVALID.value:
        await RisingEdge(dut.ACLK)
    data = int(dut.RDATA.value)
    rresp = int(dut.RRESP.value)

    for _ in range(delay_rready):
        await RisingEdge(dut.ACLK)

    dut.RREADY <= 1
    await RisingEdge(dut.ACLK)
    dut.RREADY <= 0

    return data, rresp


@cocotb.test()
async def test_axi_lite_interface(dut):
    cocotb.start_soon(Clock(dut.ACLK, 10, units="ns").start())
    dut.AWVALID <= 0
    dut.WVALID <= 0
    dut.BREADY <= 0
    dut.ARVALID <= 0
    dut.RREADY <= 0

    await reset_dut(dut)

    # Write transactions
    bresp = await write_reg(dut, 0x0, 0xDEADBEEF)
    assert bresp == 0b00

    bresp = await write_reg(dut, 0x4, 0x12345678, strb=0x7)
    assert bresp == 0b00

    bresp = await write_reg(dut, 0x8, 0xCAFEBABE, strb=0xF, delay_write=8, delay_bready=1)
    assert bresp == 0b00

    bresp = await write_reg(dut, 0xC, 0xBAADF00D, strb=0xF, delay_write=1, delay_bready=3)
    assert bresp == 0b00

    bresp = await write_reg(dut, 0x10, 0xDEADC0DE, strb=0xF, delay_write=10, delay_bready=5)
    assert bresp == 0b11

    # Read transactions
    rdata, rresp = await read_reg(dut, 0x0)
    assert rdata == 0xDEADBEEE
    assert rresp == 0b00

    rdata, rresp = await read_reg(dut, 0x4)
    assert rdata == 0x00345678
    assert rresp == 0b00

    rdata, rresp = await read_reg(dut, 0x8)
    assert rdata == 0xCAFEBABE
    assert rresp == 0b00

    rdata, rresp = await read_reg(dut, 0xC)
    assert rdata == 0xBAADF00D
    assert rresp == 0b00

    _, rresp = await read_reg(dut, 0x20)
    assert rresp == 0b11

    rdata, rresp = await read_reg(dut, 0x10)
    assert rdata == 0x00000003
    assert rresp == 0b00

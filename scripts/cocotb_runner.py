# test_runner.py

import os
from pathlib import Path

from cocotb.runner import get_runner

def test_my_design_runner():
    sim = os.getenv("SIM", "icarus")

    proj_path = Path(__file__).resolve().parent.parent

    sources = ["/mnt/c/Users/UF762PMI/Documents/Git Repositories/DMA-UVM-Project/rtl/axi_lite_reg_interface.sv"]

    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="axi_lite_reg_interface"
    )

    runner.test(hdl_toplevel="axi_lite_reg_interface", test_module= proj_path / "tb/cocotb/cocotb_axi_lite_reg_interface.py")


if __name__ == "__main__":
    test_my_design_runner()
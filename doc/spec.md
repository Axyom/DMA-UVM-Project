# DMA Controller — Specification

## Overview

This module implements a AXI4 DMA (Direct Memory Access) controller with an AXI4-Lite configuration interface. It allows memory-to-memory transfers between two AXI4 addresses, controlled by an external CPU or master via AXI4-Lite. The design includes an interrupt output to signal transfer completion.

---

## Key Features

- AXI4-Lite slave interface for control and status
- AXI4 master interface for memory transfers
- Transfer granularity: single or burst
- Configurable transfer length and addresses
- Optional interrupt signal on completion

---

## Interfaces

### AXI4-Lite (Control)

| Signal       | Direction | Description                    |
|--------------|-----------|--------------------------------|
| `ACLK`       | Input     | AXI4-Lite clock                |
| `ARESETN`    | Input     | Active-low reset               |
| `AWADDR`     | Input     | Write address                  |
| `AWVALID`    | Input     | Write address valid            |
| `WDATA`      | Input     | Write data                     |
| `WVALID`     | Input     | Write data valid               |
| `BREADY`     | Input     | Write response ready           |
| `ARADDR`     | Input     | Read address                   |
| `ARVALID`    | Input     | Read address valid             |
| `RREADY`     | Input     | Read response ready            |
| `AWREADY`    | Output    | Write address ready            |
| `WREADY`     | Output    | Write data ready               |
| `BRESP`      | Output    | Write response                 |
| `BVALID`     | Output    | Write response valid           |
| `ARREADY`    | Output    | Read address ready             |
| `RDATA`      | Output    | Read data                      |
| `RRESP`      | Output    | Read response                  |
| `RVALID`     | Output    | Read response valid            |

---

### AXI4 (Data Movement)

| Signal       | Direction | Description                         |
|--------------|-----------|-------------------------------------|
| `M_AXI_ACLK` | Input     | Clock                               |
| `M_AXI_ARESETN` | Input  | Reset                               |
| `AW*`        | Output    | Write address channel               |
| `W*`         | Output    | Write data channel                  |
| `B*`         | Input     | Write response channel              |
| `AR*`        | Output    | Read address channel                |
| `R*`         | Input     | Read data channel                   |

---

### Other Signals

| Signal     | Direction | Description                |
|------------|-----------|----------------------------|
| `irq`      | Output    | Interrupt on completion    |

---

## Register Map (AXI4-Lite)

| Address | Name             | R/W | Description                                      |
|---------|------------------|-----|--------------------------------------------------|
| 0x00    | CONTROL           | R/W | Bit 0: START, Bit 1: RESET, Bit 2: IRQ_ENABLE    |
| 0x04    | STATUS            | R   | Bit 0: BUSY, Bit 1: DONE                         |
| 0x08    | SRC_ADDR          | R/W | Source AXI address                               |
| 0x0C    | DST_ADDR          | R/W | Destination AXI address                          |
| 0x10    | LENGTH            | R/W | Transfer length in bytes                         |

---

## Operation

1. Write to `SRC_ADDR`, `DST_ADDR`, and `LENGTH`.
2. Write to `CONTROL` with START=1.
3. Controller performs AXI read and write operations.
4. `STATUS.DONE` is set when finished.
5. If enabled, `irq` is asserted for one clock cycle on completion.

---

## Assumptions and Limitations

- Only aligned accesses are supported.
- No data width adaptation.
- Only fixed-length bursts.
- No support for out-of-order or multiple outstanding transactions.
- No AXI4 protocol violations are tolerated.
- No error handling beyond STATUS.DONE.
- User is responsible for ensuring valid addresses and lengths.

---

## Generics/Parameters

| Name       | Description                 |
|------------|-----------------------------|
| `DATA_WIDTH` | Width of AXI data bus       |
| `ADDR_WIDTH` | Width of AXI address bus    |
| `BURST_LEN`  | Max burst length            |

---

## FSM Overview

States: IDLE → READ → WRITE → DONE

- **IDLE**: Wait for `START`
- **READ**: Perform AXI read transactions
- **WRITE**: Perform AXI write transactions
- **DONE**: Set `STATUS.DONE`, assert `irq` if enabled

---


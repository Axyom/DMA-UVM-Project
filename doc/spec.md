# DMA Controller Specification

## Overview

This module implements an AXI4 DMA (Direct Memory Access) controller with an AXI4-Lite configuration interface. It enables memory-to-memory transfers between two AXI4 addresses, controlled by an external CPU or master via AXI4-Lite. The design includes an interrupt output signaling transfer completion.

---

## Key Features

- AXI4-Lite slave interface for control and status  
- AXI4 master interface for memory transfers  
- Transfer granularity: single or burst  
- Configurable transfer length and addresses  
- Interrupt signal on completion  

---

## Interfaces

### AXI4-Lite (Control)

| Signal    | Direction | Description               |
|-----------|-----------|---------------------------|
| `ACLK`    | Input     | AXI4-Lite clock           |
| `ARESETN` | Input     | Active-low reset          |
| `AWADDR`  | Input     | Write address             |
| `AWVALID` | Input     | Write address valid       |
| `AWREADY` | Output    | Write address ready       |
| `WDATA`   | Input     | Write data                |
| `WVALID`  | Input     | Write data valid          |
| `WREADY`  | Output    | Write data ready          |
| `BVALID`  | Output    | Write response valid      |
| `BREADY`  | Input     | Write response ready      |
| `BRESP`   | Output    | Write response            |
| `ARADDR`  | Input     | Read address              |
| `ARVALID` | Input     | Read address valid        |
| `ARREADY` | Output    | Read address ready        |
| `RDATA`   | Output    | Read data                 |
| `RVALID`  | Output    | Read response valid       |
| `RREADY`  | Input     | Read response ready       |
| `RRESP`   | Output    | Read response             |

---

### AXI4 Master Interface (Data Movement)

| Signal          | Direction | Description                         |
|-----------------|-----------|-------------------------------------|
| `M_AXI_ACLK`    | Input     | AXI4 clock                         |
| `M_AXI_ARESETN` | Input     | AXI4 active-low reset              |

**Write Address Channel**  
| Signal          | Direction | Description                        |
|-----------------|-----------|----------------------------------|
| `M_AXI_AWID`    | Output    | Write address ID                  |
| `M_AXI_AWADDR`  | Output    | Write address                    |
| `M_AXI_AWLEN`   | Output    | Burst length (number of beats)   |
| `M_AXI_AWSIZE`  | Output    | Burst size (bytes per beat)      |
| `M_AXI_AWBURST` | Output    | Burst type (e.g., INCR, FIXED)   |
| `M_AXI_AWLOCK`  | Output    | Lock type                        |
| `M_AXI_AWCACHE` | Output    | Cache type                      |
| `M_AXI_AWPROT`  | Output    | Protection type                 |
| `M_AXI_AWVALID` | Output    | Write address valid             |
| `M_AXI_AWREADY` | Input     | Write address ready             |

**Write Data Channel**  
| Signal         | Direction | Description                       |
|----------------|-----------|---------------------------------|
| `M_AXI_WDATA`  | Output    | Write data                      |
| `M_AXI_WSTRB`  | Output    | Write strobes                   |
| `M_AXI_WLAST`  | Output    | Write last beat in burst        |
| `M_AXI_WVALID` | Output    | Write valid                    |
| `M_AXI_WREADY` | Input     | Write ready                    |

**Write Response Channel**  
| Signal         | Direction | Description                      |
|----------------|-----------|--------------------------------|
| `M_AXI_BID`    | Input     | Write response ID              |
| `M_AXI_BRESP`  | Input     | Write response status          |
| `M_AXI_BVALID` | Input     | Write response valid           |
| `M_AXI_BREADY` | Output    | Write response ready           |

**Read Address Channel**  
| Signal          | Direction | Description                      |
|-----------------|-----------|--------------------------------|
| `M_AXI_ARID`    | Output    | Read address ID                |
| `M_AXI_ARADDR`  | Output    | Read address                  |
| `M_AXI_ARLEN`   | Output    | Burst length (number of beats) |
| `M_AXI_ARSIZE`  | Output    | Burst size (bytes per beat)    |
| `M_AXI_ARBURST` | Output    | Burst type (e.g., INCR, FIXED) |
| `M_AXI_ARLOCK`  | Output    | Lock type                     |
| `M_AXI_ARCACHE` | Output    | Cache type                   |
| `M_AXI_ARPROT`  | Output    | Protection type              |
| `M_AXI_ARVALID` | Output    | Read address valid           |
| `M_AXI_ARREADY` | Input     | Read address ready           |

**Read Data Channel**  
| Signal         | Direction | Description                    |
|----------------|-----------|-------------------------------|
| `M_AXI_RID`    | Input     | Read response ID             |
| `M_AXI_RDATA`  | Input     | Read data                   |
| `M_AXI_RRESP`  | Input     | Read response status        |
| `M_AXI_RLAST`  | Input     | Read last beat in burst     |
| `M_AXI_RVALID` | Input     | Read valid                  |
| `M_AXI_RREADY` | Output    | Read ready                  |

---

### Other Signals

| Signal | Direction | Description               |
|--------|-----------|---------------------------|
| `irq`  | Output    | Interrupt on completion   |

---
## Top Diagram
![DMA Diagram](https://github.com/Axyom/DMA-UVM-Project/blob/main/doc/diagrams/DMA%20Project%20Top%20Diagram.drawio.png?raw=true)

---

## Register Map (AXI4-Lite)

We put first the writable addresses, then de readable ones to simplify design.

| Address | Name      | R/W | Description                               |
|---------|-----------|-----|-------------------------------------------|
| 0x00    | CONTROL   | R/W | Bit 0: START, Bit 1: IRQ_ENABLE |
| 0x04    | SRC_ADDR  | R/W | Source AXI address                         |
| 0x08    | DST_ADDR  | R/W | Destination AXI address                    |
| 0x0C    | LENGTH    | R/W | Transfer length in bytes                   |
| 0x10    | STATUS    | R   | Bit 0: BUSY, Bit 1: DONE                  |

---

## Operation

1. Write to `SRC_ADDR`, `DST_ADDR`, and `LENGTH`.  
2. Write to `CONTROL` with START=1.  
3. Controller performs AXI read and write transactions.  
4. `STATUS.DONE` is set when finished.  
5. If enabled, `irq` is asserted for one clock cycle on completion.

---

## Assumptions and Limitations

- Only aligned accesses supported.  
- No data width adaptation.  
- Fixed-length bursts only.  
- No out-of-order or multiple outstanding transactions.  
- No AXI protocol violations tolerated.  
- No error reporting beyond STATUS bits.  
- User responsible for valid addresses and lengths.

---

## Generics / Parameters

| Name        | Description                   |
|-------------|-------------------------------|
| `DATA_WIDTH`| Width of AXI data bus         |
| `ADDR_WIDTH`| Width of AXI address bus      |
| `BURST_LEN` | Maximum burst length          |

---

## FSM Overview

States: IDLE → READ → WRITE → DONE

- **IDLE**: Wait for `START`  
- **READ**: Perform AXI read transactions  
- **WRITE**: Perform AXI write transactions  
- **DONE**: Set `STATUS.DONE`, assert `irq` if enabled  

---

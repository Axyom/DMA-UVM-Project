# AXI4-Lite Controlled DMA Engine

## Overview

This project implements a Direct Memory Access (DMA) engine with an AXI4-Lite register interface for configuration. The DMA controller acts as an AXI4 master to perform memory-to-memory transfers between two external buffers. It is designed as a reusable and synthesizable IP core, with verification planned at both unit and system levels. System level verification will use UVM.

## Features

- AXI4-Lite slave register interface for configuration.
- AXI4 master interface for memory transfers.
- Memory-to-memory transfer with start address, destination address, and transfer size.
- One-shot transfer: no chaining, no interrupt generation.
- Supports aligned transfers only.
- Data width is parameterizable.
- Single outstanding transaction per channel (write/read).

## Architecture

- `AXI4-Lite Register Interface`: Allows the host to configure the DMA engine.
- `DMA Controller`: Implements the state machine controlling the transfer process.
- `AXI Master Interfaces`: One for reading, one for writing.
- No FIFOs or buffering; simple handshaking logic with AXI.

## Parameters

- `DATA_WIDTH` (default: 32)  
  Defines the width of the AXI data buses. Must be a multiple of 8.  
  Affects granularity of transfer units (word = DATA_WIDTH bits).  
  `TRANSFER_SIZE` register is expressed in number of words, not bytes.

## AXI Protocols

- AXI4-Lite used for register interface (slave).
- AXI4 used for burst-capable read/write transactions (master).
- Only **incrementing bursts** are used.
- Single outstanding transaction per channel (no pipelining or reordering).
- No support for wrapping or fixed bursts.

## Limitations

- No support for unaligned accesses.
- No interrupt or completion signal.
- No data width adaptation.
- No error reporting beyond basic STATUS bit.

## Goals

- Showcase RTL design and AXI4 protocol knowledge.

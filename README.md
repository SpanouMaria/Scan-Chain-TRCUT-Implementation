# Scan Chain & TRCUT Implementation  
### Testability and Dependability of Electronic Systems

This repository contains the full VHDL implementation of **scan-chain based functional testing**, based on **Exercise 1** of the course *Testability and Dependability of Electronic Systems* at the University of Ioannina.  
The project includes the Scan D Flip-Flop (SDFF), the construction of a serial scan chain, a TRCUT wrapper, and complete testbenches for functional verification of the CUT using serial scan.

---

## Overview

The goal of this exercise is to design a **scan-testable circuit (TRCUT)** using:

- **SDFFs** (Scan D Flip-Flops) for controllability and observability  
- A **serial scan chain** for shifting input vectors and capturing CUT responses  
- A **TRCUT** wrapper (Testable-Ready CUT) with a clean scan interface  
- A complete testbench implementing serial loading, capture, and serial unload  
- A timing analysis for different input sizes under scan test methodology  

All designs are implemented in VHDL or Verilog and verified through Quartus and ModelSim.

---

## SDFF & TRCUT Integration

### Implemented Modules

- `SDFF.vhd`  
  - Scan-enabled D flip-flop  
  - Supports:
    - Data mode (functional)  
    - Scan shift mode  
  - Clocked flip-flop: synchronous with `CLK`  

- `CUT.vhd`  
  - The combinational Circuit Under Test (CUT)  
  - Implements the logic provided in the assignment  
  - Verified against Quartus schematic

- `Scan_Chain.vhd`  
  - Serial chain of SDFFs  
  - Provides controllability to CUT inputs  
  - Captures CUT outputs through SDFF update stage  

- `TRCUT.vhd`  
  - Wrapper containing:
    - Scan chain  
    - CUT instance  
  - Inputs: `SI` (scan in), `SE` (scan enable), `CLK`  
  - Output: `SO` (scan out)  
  - Provides a complete scan-testing interface

The structure matches the assignment block diagram closely.

---

## Testbench for TRCUT

### Implemented Testbench: `TRCUT_tbb.vhd`

The testbench performs the complete **serial scan functional testing** procedure:

- For each truth-table input vector:
  1. **Scan-in:** Load input bits into the scan chain via shifting  
  2. **Capture:** Disable scan (`SE=0`) and apply the vector to the CUT  
  3. **Scan-out:** Shift out CUT responses through `SO`  
- Compares output bits with the expected CUT truth table  
- Stores all scan-in and scan-out cycles for waveform analysis

### Included in report:
- Full-cycle waveform captures  
- Explanation of scan mode vs capture mode  
- Verification that TRCUT outputs match expected results  


---

## Tools & Technologies

- **HDL:** VHDL
- **Design Tool:** Quartus Prime  
- **Simulation:** ModelSim 
- **Waveforms:** Collected and analyzed per assignment requirements

---

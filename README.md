# 32-bit ALU Design and Verification

**Internship:** Vaidsys Technologies  
**Domain:** VLSI Design and Functional Verification  
**Design Language:** Verilog  
**Verification Language:** SystemVerilog  
**Simulation:** AMD Vivado 2026.1 (XSim)

---

## 1. Project Overview

This project focuses on the RTL design and functional verification of a 32-bit Arithmetic Logic Unit (ALU).

The ALU supports arithmetic, logical, shift, and comparison operations. A modular, class-based SystemVerilog verification environment is used to validate its functionality through directed and randomized stimulus, a reference model, a self-checking scoreboard, and functional coverage.

The project also includes behavioral simulation using AMD Vivado XSim, with saved waveform evidence and simulation logs.

## 2. Project Objectives

- Design a 32-bit combinational ALU.
- Implement arithmetic, logical, shift, and comparison operations.
- Verify all supported and invalid opcodes.
- Test arithmetic boundary conditions and status flags.
- Develop reusable class-based verification components.
- Implement a self-checking scoreboard.
- Measure functional coverage.
- Perform behavioral simulation and analyze waveforms.

## 3. ALU Functional Specification

The ALU accepts two 32-bit operands (`a` and `b`) and a 4-bit opcode.

### Supported operations

| Opcode | Operation | Description |
|---|---|---|
| 0 | ADD | Addition |
| 1 | SUB | Subtraction |
| 2 | AND | Bitwise AND |
| 3 | OR | Bitwise OR |
| 4 | XOR | Bitwise XOR |
| 5 | NOT | Bitwise NOT of operand A |
| 6 | SLL | Logical left shift |
| 7 | SRL | Logical right shift |
| 8 | SLT | Signed less-than comparison |
| 9 | SLTU | Unsigned less-than comparison |
| A–F | Invalid | Invalid opcode handling |

### Status flags

| Flag | Description |
|---|---|
| Zero | Asserted when a valid operation produces a zero result |
| Carry | Addition carry-out or no-borrow indication for subtraction |
| Overflow | Indicates signed arithmetic overflow |
| Valid | Indicates whether the opcode is supported |

For shift operations, the shift amount is taken from the lower five bits of operand B.

## 4. Verification Architecture

The project uses a modular, class-based SystemVerilog verification environment.

### Verification components

| Component | Responsibility |
|---|---|
| Transaction | Stores stimulus and observed outputs |
| Generator | Produces directed and randomized transactions |
| Driver | Applies transactions to the DUT |
| Interface | Connects the testbench and ALU |
| Monitor | Captures DUT inputs and outputs |
| Scoreboard | Compares actual outputs with expected results |
| Coverage Collector | Tracks opcode and operand coverage |
| Environment | Instantiates and coordinates verification components |

### Verification flow

`Generator → Driver → ALU DUT → Monitor → Scoreboard and Coverage`

The scoreboard uses a reference model to calculate expected results and check the DUT outputs.

## 5. Verification Methodology

### Directed testing

Directed tests exercise all 16 opcode values, including invalid opcodes.

Additional arithmetic corner cases include:

- Signed addition overflow.
- Addition carry-out.
- Subtraction borrow.
- Signed subtraction overflow.

### Randomized testing

Randomized transactions exercise different operand values and operation combinations.

### Self-checking scoreboard

The scoreboard checks:

- Result
- Zero flag
- Carry flag
- Overflow flag
- Valid flag

### Functional coverage

The coverage collector tracks:

- Opcode coverage.
- Operand A boundary categories.
- Operand B boundary categories.
- Opcode versus operand A cross coverage.
- Opcode versus operand B cross coverage.

## 6. Simulation and Tools

| Tool | Purpose |
|---|---|
| Verilog | RTL implementation |
| SystemVerilog | Verification environment |
| AMD Vivado 2026.1 | FPGA design and simulation environment |
| Vivado XSim | Behavioral simulation |
| EDA Playground / QuestaSim 2025.2 | Earlier functional coverage development and testing |
| VS Code | Source code and documentation management |
| Git and GitHub | Version control |

The project was simulated using Vivado XSim with the `scoreboard_smoke_tb` top-level testbench.

## 7. Verification Results

The completed Day 13 regression executed 30 transactions.

### Scoreboard summary

| Metric | Result |
|---|---:|
| Directed transactions | 20 |
| Random transactions | 10 |
| Total generated | 30 |
| Total driven | 30 |
| Total monitored | 30 |
| Scoreboard checks | 30 |
| Scoreboard passes | 30 |
| Scoreboard failures | 0 |

**Simulation status: PASSED**

### Functional coverage results

| Coverage Metric | Achieved |
|---|---:|
| Opcode coverage | 100.00% |
| Operand A coverage | 60.00% |
| Operand B coverage | 20.00% |
| Opcode × Operand A | 3.75% |
| Opcode × Operand B | 2.50% |
| Overall coverage | 37.25% |

**Coverage note:** These results represent the current 30-transaction regression. Although all opcode bins were exercised, operand boundary and cross coverage are incomplete and require further testing.

## 8. Waveform Evidence

The Vivado XSim behavioral simulation waveform is saved in the `results/` directory.

| File | Description |
|---|---|
| `alu_vivado_waveform.png` | Waveform screenshot for visual inspection |
| `alu_vivado_waveform.wcfg` | Vivado waveform configuration |
| `alu_vivado_simulate.log` | Simulation execution log |

The waveform includes ALU inputs, opcode, result, status flags, and testbench synchronization signals.

## 9. Project Structure

```text
vaidsys-32bit-alu/
│
├── ALU_32bit_Verification/
│   └── ALU_32bit_Verification.xpr
│
├── rtl/
│   └── alu_32bit.sv
│
├── tb/
│   ├── day12/
│   │   ├── alu_transaction.sv
│   │   ├── alu_generator.sv
│   │   ├── alu_interface.sv
│   │   ├── alu_driver.sv
│   │   ├── alu_monitor.sv
│   │   └── alu_scoreboard.sv
│   │
│   └── day13/
│       ├── alu_coverage.sv
│       ├── alu_environment.sv
│       ├── scoreboard_smoke_tb.sv
│       └── smoke_tests/
│           └── coverage_test.sv
│
├── docs/
│   ├── alu_specification.md
│   ├── Architecture.md
│   ├── verification_plan.md
│   └── Verification_Results.md
│
├── results/
│   ├── simulation/
│   ├── synthesis/
│   ├── waveforms/
│   ├── alu_vivado_simulate.log
│   ├── alu_vivado_waveform.png
│   └── alu_vivado_waveform.wcfg
│
├── scripts/
├── sim/
├── .gitignore
└── README.md
```

## 10. Current Project Status

- 32-bit ALU RTL implementation completed.
- Class-based verification components implemented.
- Generator, driver, monitor, and scoreboard integrated.
- Verification environment implemented.
- Functional coverage collector integrated.
- 30-transaction regression completed successfully.
- Vivado XSim behavioral simulation completed.
- Waveform configuration and screenshot saved.
- Simulation log saved.
- Additional boundary-value and cross-coverage testing remains an improvement area.

## 11. Future Improvements

- Expand directed boundary-value testing.
- Improve opcode and operand cross coverage.
- Increase randomized regression size.
- Add additional assertions and corner-case checks.
- Perform synthesis and analyze resource utilization.
- Analyze timing reports and document synthesis results.
- Run a larger final regression.

---

**Project:** 32-bit ALU Design and Verification  
**Internship:** Vaidsys Technologies  
**Focus:** RTL Design and Functional Verification
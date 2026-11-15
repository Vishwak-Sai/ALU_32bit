# 32-bit ALU Design and Verification

**Internship:** Vaidsys Technologies  
**Domain:** VLSI Design and Verification  
**Project:** 32-bit Arithmetic Logic Unit (ALU)  
**HDL:** SystemVerilog

## Project Overview

This project focuses on the design and functional verification of a 32-bit combinational Arithmetic Logic Unit (ALU) using SystemVerilog.

The ALU supports arithmetic, logical, shift, and comparison operations. A self-checking verification environment is being developed to validate the functionality of the design using directed stimulus, boundary-value scenarios, and randomized testing.

## Supported ALU Operations

| Opcode | Operation | Description |
|---|---|---|
| 0 | ADD | 32-bit addition |
| 1 | SUB | 32-bit subtraction |
| 2 | AND | Bitwise AND |
| 3 | OR | Bitwise OR |
| 4 | XOR | Bitwise XOR |
| 5 | NOT | Bitwise complement of A |
| 6 | SLL | Logical shift left |
| 7 | SRL | Logical shift right |
| 8 | SLT | Signed less-than comparison |
| 9 | SLTU | Unsigned less-than comparison |
| A–F | Invalid | Unsupported operations |

### Output Flags

- **Zero:** Indicates whether the valid ALU result is zero.
- **Carry:** Indicates arithmetic carry for addition and no-borrow for subtraction.
- **Overflow:** Indicates signed arithmetic overflow.
- **Valid:** Indicates whether the selected opcode is supported.

## Verification Architecture

The project uses a modular, class-based SystemVerilog verification environment.

Components implemented:

- **Transaction:** Represents input stimulus and captured output data.
- **Generator:** Produces directed and randomized transactions.
- **Mailbox:** Transfers transactions between verification components.
- **Interface:** Connects the testbench components to the DUT.
- **Driver:** Applies stimulus to the ALU.
- **Monitor:** Captures DUT inputs and outputs.
- **Scoreboard:** Calculates expected results and compares them against actual DUT outputs.
- **Reference Model:** Provides expected ALU operation results for checking.

## Verification Strategy

The verification environment includes:

1. Directed testing of all supported and invalid opcodes.
2. Boundary-value testing for arithmetic operations.
3. Signed overflow and carry-condition testing.
4. Subtraction borrow-condition testing.
5. Randomized input stimulus.
6. Self-checking scoreboard comparisons.
7. Simulation waveform inspection.

## Tools and Technologies

- SystemVerilog
- Questa Simulator 2025.2
- EDA Playground
- EPWave
- Visual Studio Code
- Git and GitHub

## Project Progress

| Day | Milestone | Status |
|---|---|---|
| Day 1 | Specification and simulation environment setup | Completed |
| Day 2–10 | RTL design and foundational verification activities | Completed |
| Day 12 | Transaction, generator, driver, monitor, and scoreboard integration | Completed |
| Day 13 onward | Functional coverage and advanced verification activities | Upcoming |

### Day 12 Verification Results

The integrated verification environment was tested with 30 transactions.

| Metric | Result |
|---|---:|
| Transactions Generated | 30 |
| Transactions Driven | 30 |
| Transactions Monitored | 30 |
| Scoreboard Checked | 30 |
| Scoreboard Passed | 30 |
| Scoreboard Failed | 0 |

**Result: 30/30 transactions passed the scoreboard checks.**

## Project Directory Structure

```text
vaidsys-32bit-alu/
│
├── docs/
├── results/
├── rtl/
│   └── alu_32bit.sv
├── scripts/
├── sim/
└── tb/
    ├── day12/
    │   ├── smoke_tests/
    │   ├── alu_transaction.sv
    │   ├── alu_generator.sv
    │   ├── alu_interface.sv
    │   ├── alu_driver.sv
    │   ├── alu_monitor.sv
    │   ├── alu_scoreboard.sv
    │   ├── alu_environment.sv
    │   └── scoreboard_smoke_tb.sv
    └── daily_tests/
```

## Future Work

- Implement functional coverage.
- Improve randomized stimulus and constraints.
- Expand boundary-value and corner-case testing.
- Strengthen reference-model independence.
- Perform regression testing.
- Analyze functional coverage results.
- Integrate and validate the complete verification environment.

## Internship

**Vaidsys Technologies**  
VLSI Design and Verification Internship

This project is being developed incrementally as part of the internship, with implementation details, verification results, and milestones documented throughout the development process.
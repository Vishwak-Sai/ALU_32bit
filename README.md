# 32-bit ALU Design and Verification

**Internship:** Vaidsys Technologies  
**Domain:** VLSI Design and Functional Verification  
**HDL:** Verilog / SystemVerilog  
**Simulation:** QuestaSim 2025.2 (EDA Playground)

## 1. Project Overview

This project focuses on the design and functional verification of a 32-bit Arithmetic Logic Unit (ALU) using Verilog and SystemVerilog.

The ALU performs arithmetic, logical, shift and comparison operations. A class-based SystemVerilog testbench is developed to verify the functionality of the ALU using directed and randomized stimulus, a reference model, a self-checking scoreboard and functional coverage.

## 2. Project Objectives

- Design a 32-bit combinational ALU.
- Implement arithmetic, logical, shift and comparison operations.
- Verify all supported and invalid opcodes.
- Test arithmetic boundary conditions and status flags.
- Develop a reusable class-based verification environment.
- Measure functional coverage of opcodes and operand scenarios.

## 3. Supported ALU Operations

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
| A–F | Invalid | Invalid operation handling |

### Status Flags

The ALU generates the following status signals:

- **Zero:** Indicates whether the valid operation result is zero.
- **Carry:** Indicates arithmetic carry for addition or no-borrow for subtraction.
- **Overflow:** Indicates signed arithmetic overflow.
- **Valid:** Indicates whether the opcode is supported.

## 4. Verification Architecture

The project uses a modular, class-based SystemVerilog verification environment.

### Verification Components

| Component | Responsibility |
|---|---|
| Transaction | Stores input stimulus and observed outputs |
| Generator | Produces directed and randomized transactions |
| Driver | Applies transactions to the DUT |
| Interface | Connects the testbench to the ALU |
| Monitor | Captures DUT inputs and outputs |
| Scoreboard | Compares actual outputs against expected results |
| Coverage Collector | Tracks opcode and operand scenarios |
| Environment | Instantiates and manages verification components |

### Verification Flow

Generator → Driver → ALU DUT → Monitor → Scoreboard and Coverage Collector

The scoreboard uses a reference model to calculate expected outputs and identify mismatches.

## 5. Verification Methodology

The following verification techniques are implemented:

### Directed Testing

Directed transactions exercise all 16 opcode values, including invalid opcodes.

Additional arithmetic corner cases include:

- Signed addition overflow.
- Addition carry.
- Subtraction borrow.
- Signed subtraction overflow.

### Randomized Testing

Randomized transactions exercise different operand values and operation combinations.

### Self-Checking Scoreboard

The scoreboard compares the DUT outputs with the reference model, checking:

- Result
- Zero flag
- Carry flag
- Overflow flag
- Valid flag

### Functional Coverage

The coverage collector tracks:

- Opcode coverage.
- Operand A boundary categories.
- Operand B boundary categories.
- Opcode versus operand A cross coverage.
- Opcode versus operand B cross coverage.

## 6. Tools and Technologies

- Verilog
- SystemVerilog
- EDA Playground
- QuestaSim 2025.2
- EPWave

## 7. Latest Verification Results

The latest completed simulation executed 30 transactions:

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

### Functional Coverage Results

| Coverage Metric | Achieved |
|---|---:|
| Opcode coverage | 100.00% |
| Operand A coverage | 60.00% |
| Operand B coverage | 20.00% |
| Opcode × Operand A | 3.75% |
| Opcode × Operand B | 2.50% |
| Overall coverage | 37.25% |

**Note:** These are the results from the current 30-transaction regression. Operand boundary and cross coverage remain areas for improvement.

## 8. Project Structure

```text
vaidsys-32bit-alu/
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
│       └── scoreboard_smoke_tb.sv
│
├── docs/
├── results/
├── scripts/
└── sim/
```

## 9. Current Project Status

- ALU RTL implementation completed.
- Class-based verification components implemented.
- Generator, driver, monitor and scoreboard integrated.
- Verification environment implemented.
- Functional coverage collector integrated.
- 30-transaction simulation completed successfully.
- Boundary-value and cross coverage improvements pending.
- Final regression and documentation refinement pending.

## 10. Future Improvements

- Expand directed boundary-value testing.
- Improve opcode and operand cross coverage.
- Increase randomized regression size.
- Add additional assertions and corner-case checks.
- Perform final regression and document waveform results.

---

**Project:** 32-bit ALU Design and Verification  
**Internship:** Vaidsys Technologies  
**Focus:** RTL Design and Functional Verification
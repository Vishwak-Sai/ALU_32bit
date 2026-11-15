# 32-bit ALU Design and Verification Architecture

## 1. Introduction

This document describes the architecture of the 32-bit Arithmetic Logic Unit (ALU) and its SystemVerilog-based verification environment.

The project consists of two major parts:

1. **Design Under Test (DUT):** A combinational 32-bit ALU that performs arithmetic, logical, shift, and comparison operations.
2. **Verification Environment:** A class-based SystemVerilog testbench that generates input transactions, drives the DUT, monitors its outputs, checks results using a scoreboard, and collects functional coverage.

## 2. Overall Architecture

The project follows a modular verification architecture.

### Design Architecture

The ALU receives two 32-bit operands and a 4-bit opcode. Based on the opcode, it performs the selected operation and produces a 32-bit result along with status flags.

### Verification Architecture

The verification environment contains the following components:

- Transaction
- Generator
- Interface
- Driver
- Monitor
- Scoreboard
- Functional Coverage
- Environment
- Top-Level Testbench

## 3. ALU Design Architecture

### 3.1 DUT Interface

The ALU has two 32-bit input operands, one 4-bit opcode, and four output signals.

| Signal | Direction | Width | Description |
|---|---|---:|---|
| `a` | Input | 32 bits | First operand |
| `b` | Input | 32 bits | Second operand |
| `opcode` | Input | 4 bits | Operation selector |
| `result` | Output | 32 bits | ALU operation result |
| `zero` | Output | 1 bit | Indicates zero result for a valid operation |
| `carry` | Output | 1 bit | Carry or no-borrow indicator |
| `overflow` | Output | 1 bit | Signed arithmetic overflow indicator |
| `valid` | Output | 1 bit | Indicates a supported opcode |

### 3.2 Operation Selection

The ALU uses a combinational `always_comb` block and a `case` statement to select the operation.

| Opcode | Operation | Description |
|---|---|---|
| `4'h0` | ADD | Adds operands A and B |
| `4'h1` | SUB | Subtracts B from A |
| `4'h2` | AND | Bitwise AND |
| `4'h3` | OR | Bitwise OR |
| `4'h4` | XOR | Bitwise XOR |
| `4'h5` | NOT | Bitwise complement of A |
| `4'h6` | SLL | Logical left shift |
| `4'h7` | SRL | Logical right shift |
| `4'h8` | SLT | Signed less-than comparison |
| `4'h9` | SLTU | Unsigned less-than comparison |
| `4'hA–4'hF` | Invalid | Unsupported operation |

### 3.3 Status Flag Generation

The ALU generates four status signals.

- **Zero:** Asserted when a valid operation produces a zero result.
- **Carry:** For ADD, indicates carry-out. For SUB, indicates no borrow.
- **Overflow:** Indicates signed overflow during addition or subtraction.
- **Valid:** Asserted for supported opcodes from `0` through `9`.

For logical, shift, and comparison operations, carry and overflow remain at their default value of zero.

For invalid opcodes, the result and status outputs are set to their default values, with `valid = 0`.

## 4. Verification Environment Architecture

### 4.1 Transaction Class

The transaction class represents one ALU operation.

It contains:

- Opcode
- Operand A
- Operand B
- Expected result and flags
- Actual result and flags
- Transaction ID

The generator creates transaction objects, and the monitor creates observed transaction data for scoreboard checking and coverage sampling.

### 4.2 Generator

The generator creates stimulus transactions and sends them to the driver through a mailbox.

It supports:

- Directed testing
- Randomized testing
- Transaction ID assignment

Directed transactions are used for specific operation and boundary scenarios. Randomized transactions provide additional operand and opcode combinations.

### 4.3 Interface

The interface connects the testbench to the DUT.

It contains:

- DUT input signals
- DUT output signals
- Testbench sampling signal
- Transaction ID signal

The interface provides a common connection point for the driver, monitor, and DUT.

### 4.4 Driver

The driver receives transactions from the generator mailbox and applies their input values to the DUT through the virtual interface.

Its responsibilities include:

1. Receive a transaction.
2. Drive opcode and operands.
3. Allow combinational logic to settle.
4. Generate the sampling pulse.
5. Continue with the next transaction.

### 4.5 Monitor

The monitor observes the DUT through the virtual interface.

It waits for the sampling event and captures:

- Input operands
- Opcode
- Actual result
- Zero flag
- Carry flag
- Overflow flag
- Valid flag
- Transaction ID

The monitor sends the observed transaction to the scoreboard mailbox and forwards the transaction to the functional coverage model for sampling.

### 4.6 Scoreboard

The scoreboard checks the DUT output against the expected output calculated by its reference model.

It performs the following checks:

- Result comparison
- Zero flag comparison
- Carry flag comparison
- Overflow flag comparison
- Valid flag comparison

It maintains transaction statistics, including:

- Total transactions checked
- Passed transactions
- Failed transactions

A mismatch is reported when an actual DUT output differs from its expected value.

### 4.7 Functional Coverage

The functional coverage component uses SystemVerilog covergroups to measure which functional scenarios have been exercised.

The coverage model includes:

1. Opcode coverage.
2. Operand A boundary-value coverage.
3. Operand B boundary-value coverage.
4. Opcode versus Operand A cross coverage.
5. Opcode versus Operand B cross coverage.

The monitor calls the coverage sampling method for each observed transaction.

### 4.8 Environment

The environment class instantiates and connects the verification components.

It creates the required mailboxes and connects:

- Generator to Driver
- Monitor to Scoreboard
- Monitor to Functional Coverage

It also provides methods to run the verification environment and display the verification summary.

### 4.9 Top-Level Testbench

The top-level testbench performs the following tasks:

1. Creates the ALU interface.
2. Instantiates the ALU DUT.
3. Connects the DUT to the interface.
4. Creates the verification environment.
5. Starts the environment.
6. Displays scoreboard and coverage summaries.
7. Checks the final scoreboard status.

## 5. Verification Data Flow

The following diagram represents the transaction flow through the implemented verification environment.

```text
                 TOP-LEVEL TESTBENCH
                         |
                         v
                  ALU ENVIRONMENT
                         |
              +----------+----------+
              |                     |
              v                     v
          GENERATOR              COVERAGE
              |                     ^
              v                     |
       Generator Mailbox            |
              |                     |
              v                     |
           DRIVER                  |
              |                     |
              v                     |
        VIRTUAL INTERFACE           |
              |                     |
              v                     |
             DUT -------------------+
              |
              v
           MONITOR
              |
              v
       Monitor Mailbox
              |
              v
          SCOREBOARD
              |
              v
       PASS / FAIL REPORT
```

**Note:** The diagram shows the functional data flow. The monitor observes the DUT through the interface and supplies the observed transaction to both the scoreboard and coverage model.

## 6. Mailbox Communication

Mailboxes provide communication between the class-based verification components.

| Mailbox | Sender | Receiver | Purpose |
|---|---|---|---|
| `gen2drv` | Generator | Driver | Transfers generated transactions |
| `mon2scb` | Monitor | Scoreboard | Transfers observed DUT transactions |

This approach separates stimulus generation, signal driving, monitoring, and checking.

## 7. Simulation Execution Flow

The simulation follows this sequence:

1. The top-level testbench instantiates the DUT and interface.
2. The environment constructs the verification components.
3. The generator creates directed and randomized transactions.
4. The driver receives transactions and applies them to the DUT.
5. The ALU evaluates the input combination.
6. The monitor captures the DUT inputs and outputs.
7. The scoreboard compares actual and expected values.
8. Functional coverage samples the observed transaction.
9. The environment displays the final verification summary.

## 8. Verification Tools

| Tool | Purpose |
|---|---|
| SystemVerilog | RTL design and verification development |
| EDA Playground | Online simulation environment |
| QuestaSim 2025.2 | Compilation and simulation |
| EPWave | Waveform visualization |
| Git and GitHub | Source code management |

The current functional coverage simulation was executed using QuestaSim 2025.2 on EDA Playground.

## 9. Current Architecture Status

| Component | Status |
|---|---|
| 32-bit ALU RTL | Implemented |
| Transaction Class | Implemented |
| Generator | Implemented |
| Interface | Implemented |
| Driver | Implemented |
| Monitor | Implemented |
| Scoreboard | Implemented |
| Functional Coverage | Implemented |
| Environment | Implemented |
| Top-Level Testbench | Implemented |
| Directed and Randomized Smoke Test | Executed |
| Assertions | Future Enhancement |

## 10. Conclusion

The project uses a modular SystemVerilog verification architecture to verify a combinational 32-bit ALU.

The separation of generator, driver, monitor, scoreboard, and functional coverage makes the environment easier to maintain and extend.

The current architecture supports directed and randomized stimulus, automatic output checking, transaction monitoring, and functional coverage collection.

Future enhancements will focus on assertions, improved constrained-random stimulus, increased cross coverage, and larger regression testing.

---

**Project:** 32-bit ALU Design and Verification  
**Document:** Architecture  
**Verification Methodology:** Modular Class-Based SystemVerilog Testbench
32-bit ALU Specification

1. Project Objective
Design and verify a 32-bit Arthmetic Logic Unit (ALU) using SystemVerilog. The ALU supports arthmetic, logical, shift, and comaprison operations.

2. Interface
Inputs
> a: 32-bit operand A
> b: 32-bit operand B
> opcode: 4-bit operations selector

Outputs
> result: 32-bit operation result
> zero: 1 when zero is result
> carry: arithmetic carry/ no-borrow indicator
> overflow: signed arithmetic overflow indicator 
> valid: 1 when opcode is supported

3. Opcode Mapping

opcode                  Operation
0x0                     ADD
0x1                     SUB
0x2                     AND
0x3                     OR
0x4                     XOR
0x5                     NOT
0x6                     SLL
0x7                     SRL
0x8                     SLT
0x9                     SLTU
0xA - 0xF               Invalid

4. Operation Definations
> ADD: result = a + b, with 32-bit truncation.
> SUB: result = a - b, with 32-bit truncation.
> AND: bitwise AND of a and b.
> OR: bitwise OR of a and b.
> XOR: bitwise XOR of a and b.
> NOT: bitwise compliment of a.
> SLL: logical left shift of a by b[4:0].
> SRL: logical right shift of a by b[4:0].
> SLT: signed compariosn of a and b; result is 1 if a<b, otherwise 0.
> SLUT: usingned comparison of a and b; result is 1 if a<b, otherwise 0.

5. Flag Definations
> zero: 1 if result equals zero, otherwise 0.
> carry for ADD: unsigned carry-out beyond bit 31.
> carry for SUB: when no unsigned borrow occurs, otherwise 0.
> overflow for ADD: 1 when signed addition overflows the 32-bit signed range.
> overflow for SUB: 1 when signed subtraction overflows the 32-bit signed range.
> For non-arithmetic operations, carry and overflow are 0.
> For valid opcodes, valid is 1.
> For invalid opcodes, valid is 0, result is 0, and all falgs are 0.

6. Design Constraints
> The ALU is purely combinational.
> No clock or reset is required.
> All outputs must be asssigned for every possible input.
> No unintended latch inference is allowed.
> Arithmetic results wrap to 32 bits.
> Shift amount is restricted to 0 through 31 using b[4:0].

7. Verification Goal
Verify all supported operations, invlaid opcodes, flag behaviour, arithmetic boundaries, shift boundaries, and signed/unsigned comparisons using an independent reference model and a self-checking testbench.
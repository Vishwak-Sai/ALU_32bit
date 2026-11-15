ALU Verification Plan

1. Verification Objective

Verify the functional correctness of the 32-bit ALU against the approved specification.

2. Verification Strategy

1. Run directed tests for every supported operation.
2. Test arithmetic corner cases and flags.
3. Test shift amounts at their boundaries.
4. Verify signed and unsigned comparisons.
5. Test every invalid opcode.
6. Develop an independent reference model.
7. Compare DUT outputs against expected outputs.
8. Add reproducible randomized testing.
9. Record test results and investigate every mismatch.

3. Directed Test Categories

- ADD and SUB: zero, carry, borrow and signed overflow.
- Logic: zero, all-one and alternating-bit patterns.
- Shifts: 0, 1, 15, 16 and 31.
- Comparisons: less than, equal and greater than for signed and unsigned values.
- Invalid opcodes: 0xA through 0xF.
- Flags: zero, carry, overflow and valid.

4. Pass Criteria

- Every implemented operation matches the reference model.
- All specified directed tests pass.
- All invalid opcodes produce the specified outputs.
- No unintended latch is inferred during synthesis.
- Randomized regression completes without unexplained mismatches.
- All failures and known limitations are documented.

5. Coverage Goals

Track execution of all valid opcodes, all invalid opcodes, arithmetic boundary scenarios, shift boundary values, and signed/unsigned comparison scenarios.

Report the coverage actually measured. Do not claim coverage that was not collected.
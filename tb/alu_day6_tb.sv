
`timescale 1ns/1ps

module alu_day6_tb;

    // =========================================
    // 1. INPUT AND OUTPUT SIGNALS
    // =========================================

    logic [31:0] a;
    logic [31:0] b;
    logic [3:0] opcode;

    logic [31:0] result;
    logic zero;
    logic carry;
    logic overflow;
    logic valid;

    integer pass_count;
    integer fail_count;
    integer i;

    // =========================================
    // 2. DUT INSTANTIATION
    // =========================================

    alu_32bit dut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .zero(zero),
        .carry(carry),
        .overflow(overflow),
        .valid(valid)
    );

    // =========================================
    // 3. INDEPENDENT REFERENCE MODEL
    // =========================================

    task automatic reference_model(

        input logic [3:0]  ref_opcode,
        input logic [31:0] ref_a,
        input logic [31:0] ref_b,

        output logic [31:0] expected_result,
        output logic        expected_zero,
        output logic        expected_carry,
        output logic        expected_overflow,
        output logic        expected_valid

    );

        logic [32:0] temp;

        begin

            // Default expected outputs
            expected_result   = 32'b0;
            expected_zero     = 1'b0;
            expected_carry    = 1'b0;
            expected_overflow = 1'b0;
            expected_valid   = 1'b0;

            temp = 33'b0;

            case (ref_opcode)

                // ADD
                4'h0: begin

                    expected_valid = 1'b1;

                    temp = {1'b0, ref_a} +
                           {1'b0, ref_b};

                    expected_result = temp[31:0];

                    expected_carry = temp[32];

                    expected_overflow =
                        (~(ref_a[31] ^ ref_b[31])) &
                        (expected_result[31] ^ ref_a[31]);

                end

                // SUB
                4'h1: begin

                    expected_valid = 1'b1;

                    expected_result = ref_a - ref_b;

                    // Carry means NO unsigned borrow
                    expected_carry = (ref_a >= ref_b);

                    expected_overflow =
                        (ref_a[31] ^ ref_b[31]) &
                        (expected_result[31] ^ ref_a[31]);

                end

                // AND
                4'h2: begin

                    expected_valid = 1'b1;
                    expected_result = ref_a & ref_b;

                end

                // OR
                4'h3: begin

                    expected_valid = 1'b1;
                    expected_result = ref_a | ref_b;

                end

                // XOR
                4'h4: begin

                    expected_valid = 1'b1;
                    expected_result = ref_a ^ ref_b;

                end

                // NOT
                4'h5: begin

                    expected_valid = 1'b1;
                    expected_result = ~ref_a;

                end

                // SLL
                4'h6: begin

                    expected_valid = 1'b1;
                    expected_result = ref_a << ref_b[4:0];

                end

                // SRL
                4'h7: begin

                    expected_valid = 1'b1;
                    expected_result = ref_a >> ref_b[4:0];

                end

                // SLT - Signed comparison
                4'h8: begin

                    expected_valid = 1'b1;

                    expected_result =
                        ($signed(ref_a) < $signed(ref_b))
                        ? 32'd1 : 32'd0;

                end

                // SLTU - Unsigned comparison
                4'h9: begin

                    expected_valid = 1'b1;

                    expected_result =
                        (ref_a < ref_b) ? 32'd1 : 32'd0;

                end

                // Invalid opcodes
                default: begin

                    expected_valid = 1'b0;

                end

            endcase

            // Expected zero flag
            expected_zero =
                expected_valid &&
                (expected_result == 32'b0);

        end

    endtask


    // =========================================
    // 4. SELF-CHECKING VERIFICATION TASK
    // =========================================

    task automatic check_operation(

        input logic [3:0]  test_opcode,
        input logic [31:0] test_a,
        input logic [31:0] test_b

    );

        logic [31:0] exp_result;
        logic exp_zero;
        logic exp_carry;
        logic exp_overflow;
        logic exp_valid;

        begin

            // Calculate expected outputs independently
            reference_model(
                test_opcode,
                test_a,
                test_b,
                exp_result,
                exp_zero,
                exp_carry,
                exp_overflow,
                exp_valid
            );

            // Apply stimulus to DUT
            a = test_a;
            b = test_b;
            opcode = test_opcode;

            // Allow combinational logic to settle
            #1;

            // Compare actual and expected outputs
            if (
                result   !== exp_result   ||
                zero     !== exp_zero     ||
                carry    !== exp_carry    ||
                overflow !== exp_overflow ||
                valid    !== exp_valid
            ) begin

                $display("--------------------------------");
                $display("FAIL");
                $display("Opcode = %h", test_opcode);
                $display("A      = %h", test_a);
                $display("B      = %h", test_b);

                $display("EXPECTED RESULT   = %h", exp_result);
                $display("ACTUAL RESULT     = %h", result);

                $display("EXPECTED ZERO     = %b", exp_zero);
                $display("ACTUAL ZERO       = %b", zero);

                $display("EXPECTED CARRY    = %b", exp_carry);
                $display("ACTUAL CARRY      = %b", carry);

                $display("EXPECTED OVERFLOW = %b", exp_overflow);
                $display("ACTUAL OVERFLOW   = %b", overflow);

                $display("EXPECTED VALID    = %b", exp_valid);
                $display("ACTUAL VALID      = %b", valid);

                fail_count = fail_count + 1;

            end

            else begin

                $display(
                    "PASS: OP=%h A=%h B=%h RESULT=%h Z=%b C=%b OVF=%b V=%b",
                    test_opcode,
                    test_a,
                    test_b,
                    result,
                    zero,
                    carry,
                    overflow,
                    valid
                );

                pass_count = pass_count + 1;

            end

        end

    endtask


    // =========================================
    // 5. MAIN TEST SEQUENCE
    // =========================================

    initial begin

        $dumpfile("alu_day6.vcd");
        $dumpvars(0, alu_day6_tb);

        pass_count = 0;
        fail_count = 0;

        a = 32'b0;
        b = 32'b0;
        opcode = 4'b0;

        $display("========================================");
        $display("DAY 6: COMPLETE ALU FUNCTIONAL TEST");
        $display("========================================");


        // -------------------------------------
        // ADD TESTS
        // -------------------------------------

        $display("\n--- ADD TESTS ---");

        check_operation(4'h0, 32'd10, 32'd5);

        check_operation(4'h0, 32'hFFFFFFFF, 32'h00000001);

        check_operation(4'h0, 32'h7FFFFFFF, 32'h00000001);

        check_operation(4'h0, 32'h80000000, 32'h80000000);


        // -------------------------------------
        // SUB TESTS
        // -------------------------------------

        $display("\n--- SUB TESTS ---");

        check_operation(4'h1, 32'd10, 32'd5);

        check_operation(4'h1, 32'd3, 32'd5);

        check_operation(4'h1, 32'h80000000, 32'h00000001);

        check_operation(4'h1, 32'h7FFFFFFF, 32'hFFFFFFFF);


        // -------------------------------------
        // LOGICAL TESTS
        // -------------------------------------

        $display("\n--- LOGICAL TESTS ---");

        check_operation(4'h2, 32'hF0F0F0F0, 32'h0FF00FF0);

        check_operation(4'h3, 32'h0F0F0F0F, 32'hF0F0F0F0);

        check_operation(4'h4, 32'hAAAAAAAA, 32'h55555555);

        check_operation(4'h5, 32'h00000000, 32'hFFFFFFFF);


        // -------------------------------------
        // SHIFT TESTS
        // -------------------------------------

        $display("\n--- SHIFT TESTS ---");

        check_operation(4'h6, 32'h00000001, 32'd1);

        check_operation(4'h6, 32'h00000001, 32'd31);

        check_operation(4'h6, 32'hAAAAAAAA, 32'd0);

        check_operation(4'h7, 32'h80000000, 32'd1);

        check_operation(4'h7, 32'hFFFFFFFF, 32'd31);

        check_operation(4'h7, 32'hAAAAAAAA, 32'd0);


        // -------------------------------------
        // COMPARISON TESTS
        // -------------------------------------

        $display("\n--- COMPARISON TESTS ---");

        check_operation(4'h8, 32'hFFFFFFFF, 32'h00000001);

        check_operation(4'h8, 32'h80000000, 32'h7FFFFFFF);

        check_operation(4'h8, 32'd5, 32'd5);

        check_operation(4'h9, 32'hFFFFFFFF, 32'h00000001);

        check_operation(4'h9, 32'h00000001, 32'hFFFFFFFF);

        check_operation(4'h9, 32'd5, 32'd5);


        // -------------------------------------
        // INVALID OPCODE TESTS
        // -------------------------------------

        $display("\n--- INVALID OPCODE TESTS ---");

        for (i = 10; i < 16; i = i + 1) begin

            check_operation(
                i[3:0],
                32'hAAAAAAAA,
                32'h55555555
            );

        end


        // -------------------------------------
        // FINAL SUMMARY
        // -------------------------------------

        $display("\n========================================");
        $display("DAY 6 VERIFICATION SUMMARY");
        $display("========================================");

        $display("TOTAL TESTS = %0d", pass_count + fail_count);
        $display("TOTAL PASS  = %0d", pass_count);
        $display("TOTAL FAIL  = %0d", fail_count);

        if (fail_count == 0)
            $display("DAY 6 VERIFICATION PASSED");
        else
            $display("DAY 6 VERIFICATION FAILED");

        $display("========================================");

        $finish;

    end

endmodule

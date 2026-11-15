
`timescale 1ns/1ps

module alu_day10_tb;

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


    // =========================================
    // 2. TEST COUNTERS
    // =========================================

    integer pass_count;
    integer fail_count;

    integer assertion_check_count;
    integer assertion_fail_count;

    integer i;
    integer k;


    // =========================================
    // 3. DAY 9 COVERAGE COUNTERS
    // =========================================

    integer opcode_hits [0:15];
    integer opcode_bins_hit;

    integer zero_operand_hits;
    integer all_ones_hits;
    integer sign_boundary_hits;

    integer shift_zero_hits;
    integer shift_one_hits;
    integer shift_max_hits;

    integer carry_hits;
    integer overflow_hits;
    integer zero_result_hits;
    integer invalid_opcode_hits;


    // =========================================
    // 4. DAY 10 CROSS COVERAGE VARIABLES
    // =========================================

    integer class_a;
    integer class_b;

    integer opcode_loop;
    integer ca;
    integer cb;

    integer cross_hits [0:249];

    integer cross_bins_hit;
    integer cross_index;


    // =========================================
    // 5. DUT INSTANTIATION
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
    // 6. OPERAND CLASSIFICATION FUNCTION
    // =========================================

    function automatic integer classify_operand(
        input logic [31:0] value
    );

        begin

            case (value)

                32'h00000000:
                    classify_operand = 0;

                32'hFFFFFFFF:
                    classify_operand = 1;

                32'h80000000:
                    classify_operand = 2;

                32'h7FFFFFFF:
                    classify_operand = 3;

                32'hAAAAAAAA:
                    classify_operand = 4;

                default:
                    classify_operand = -1;

            endcase

        end

    endfunction


    // =========================================
    // 7. OPERAND VALUE GENERATION FUNCTION
    // =========================================

    function automatic logic [31:0] operand_value(
        input integer class_id
    );

        begin

            case (class_id)

                0: operand_value = 32'h00000000;

                1: operand_value = 32'hFFFFFFFF;

                2: operand_value = 32'h80000000;

                3: operand_value = 32'h7FFFFFFF;

                4: operand_value = 32'hAAAAAAAA;

                default:
                    operand_value = 32'h00000000;

            endcase

        end

    endfunction


    // =========================================
    // 8. INDEPENDENT REFERENCE MODEL
    // =========================================

    task automatic reference_model(

        input logic [3:0] ref_opcode,
        input logic [31:0] ref_a,
        input logic [31:0] ref_b,

        output logic [31:0] expected_result,
        output logic expected_zero,
        output logic expected_carry,
        output logic expected_overflow,
        output logic expected_valid

    );

        logic [32:0] temp;

        begin

            expected_result   = 32'b0;
            expected_zero     = 1'b0;
            expected_carry    = 1'b0;
            expected_overflow = 1'b0;
            expected_valid    = 1'b0;

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

                    // Carry means no unsigned borrow

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


                // SLT - SIGNED

                4'h8: begin

                    expected_valid = 1'b1;

                    expected_result =
                        ($signed(ref_a) < $signed(ref_b))
                        ? 32'd1 : 32'd0;

                end


                // SLTU - UNSIGNED

                4'h9: begin

                    expected_valid = 1'b1;

                    expected_result =
                        (ref_a < ref_b)
                        ? 32'd1 : 32'd0;

                end


                // INVALID OPCODES

                default: begin

                    expected_valid = 1'b0;

                end

            endcase


            // ZERO FLAG

            expected_zero =
                expected_valid &&
                (expected_result == 32'b0);

        end

    endtask


    // =========================================
    // 9. SELF-CHECKING VERIFICATION TASK
    // =========================================

    task automatic check_operation(

        input logic [3:0] test_opcode,
        input logic [31:0] test_a,
        input logic [31:0] test_b

    );

        logic [31:0] exp_result;

        logic exp_zero;
        logic exp_carry;
        logic exp_overflow;
        logic exp_valid;

        begin

            // ---------------------------------
            // STEP 1: REFERENCE MODEL
            // ---------------------------------

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


            // ---------------------------------
            // STEP 2: APPLY INPUTS
            // ---------------------------------

            a = test_a;
            b = test_b;
            opcode = test_opcode;

            #1;


            // ---------------------------------
            // STEP 3: IMMEDIATE ASSERTIONS
            // ---------------------------------

            assertion_check_count =
                assertion_check_count + 5;


            assert (result === exp_result)
            else begin

                $display("ASSERTION FAILED: RESULT");

                assertion_fail_count =
                    assertion_fail_count + 1;

            end


            assert (zero === exp_zero)
            else begin

                $display("ASSERTION FAILED: ZERO");

                assertion_fail_count =
                    assertion_fail_count + 1;

            end


            assert (carry === exp_carry)
            else begin

                $display("ASSERTION FAILED: CARRY");

                assertion_fail_count =
                    assertion_fail_count + 1;

            end


            assert (overflow === exp_overflow)
            else begin

                $display("ASSERTION FAILED: OVERFLOW");

                assertion_fail_count =
                    assertion_fail_count + 1;

            end


            assert (valid === exp_valid)
            else begin

                $display("ASSERTION FAILED: VALID");

                assertion_fail_count =
                    assertion_fail_count + 1;

            end


            // ---------------------------------
            // STEP 4: SCOREBOARD COMPARISON
            // ---------------------------------

            if (
                result   !== exp_result   ||
                zero     !== exp_zero     ||
                carry    !== exp_carry    ||
                overflow !== exp_overflow ||
                valid    !== exp_valid
            ) begin

                $display("--------------------------------");
                $display("FAIL");

                $display("OPCODE = %h", test_opcode);
                $display("A = %h", test_a);
                $display("B = %h", test_b);

                $display("EXPECTED RESULT = %h", exp_result);
                $display("ACTUAL RESULT = %h", result);

                $display("EXPECTED ZERO = %b", exp_zero);
                $display("ACTUAL ZERO = %b", zero);

                $display("EXPECTED CARRY = %b", exp_carry);
                $display("ACTUAL CARRY = %b", carry);

                $display("EXPECTED OVERFLOW = %b", exp_overflow);
                $display("ACTUAL OVERFLOW = %b", overflow);

                $display("EXPECTED VALID = %b", exp_valid);
                $display("ACTUAL VALID = %b", valid);

                fail_count = fail_count + 1;

            end

            else begin

                $display(
                    "PASS: OP=%h A=%h B=%h RESULT=%h",
                    test_opcode,
                    test_a,
                    test_b,
                    result
                );

                pass_count = pass_count + 1;

            end


            // =================================
            // STEP 5: OPCODE COVERAGE
            // =================================

            opcode_hits[test_opcode] =
                opcode_hits[test_opcode] + 1;


            // =================================
            // STEP 6: OPERAND COVERAGE
            // =================================

            if (
                test_a == 32'h00000000 ||
                test_b == 32'h00000000
            )

                zero_operand_hits =
                    zero_operand_hits + 1;


            if (
                test_a == 32'hFFFFFFFF ||
                test_b == 32'hFFFFFFFF
            )

                all_ones_hits =
                    all_ones_hits + 1;


            if (
                test_a == 32'h80000000 ||
                test_a == 32'h7FFFFFFF ||
                test_b == 32'h80000000 ||
                test_b == 32'h7FFFFFFF
            )

                sign_boundary_hits =
                    sign_boundary_hits + 1;


            // =================================
            // STEP 7: SHIFT COVERAGE
            // =================================

            if (
                test_opcode == 4'h6 ||
                test_opcode == 4'h7
            ) begin

                case (test_b[4:0])

                    5'd0:
                        shift_zero_hits =
                            shift_zero_hits + 1;

                    5'd1:
                        shift_one_hits =
                            shift_one_hits + 1;

                    5'd31:
                        shift_max_hits =
                            shift_max_hits + 1;

                    default: begin
                    end

                endcase

            end


            // =================================
            // STEP 8: FLAG COVERAGE
            // =================================

            if (carry == 1'b1)
                carry_hits = carry_hits + 1;

            if (overflow == 1'b1)
                overflow_hits = overflow_hits + 1;

            if (zero == 1'b1)
                zero_result_hits = zero_result_hits + 1;


            // =================================
            // STEP 9: INVALID OPCODE COVERAGE
            // =================================

            if (test_opcode >= 4'hA)

                invalid_opcode_hits =
                    invalid_opcode_hits + 1;


            // =================================
            // STEP 10: CROSS COVERAGE
            // =================================

            class_a = classify_operand(test_a);

            class_b = classify_operand(test_b);

            if (
                test_opcode <= 4'h9 &&
                class_a >= 0 &&
                class_b >= 0
            ) begin

                cross_index =
                    (test_opcode * 25) +
                    (class_a * 5) +
                    class_b;

                cross_hits[cross_index] =
                    cross_hits[cross_index] + 1;

            end

        end

    endtask


    // =========================================
    // 10. MAIN TEST SEQUENCE
    // =========================================

    initial begin

        // Waveform generation

        $dumpfile("alu_day10.vcd");
        $dumpvars(0, alu_day10_tb);


        // -------------------------------------
        // INITIALIZE COUNTERS
        // -------------------------------------

        pass_count = 0;
        fail_count = 0;

        assertion_check_count = 0;
        assertion_fail_count = 0;


        // Day 9 coverage initialization

        zero_operand_hits = 0;
        all_ones_hits = 0;
        sign_boundary_hits = 0;

        shift_zero_hits = 0;
        shift_one_hits = 0;
        shift_max_hits = 0;

        carry_hits = 0;
        overflow_hits = 0;
        zero_result_hits = 0;

        invalid_opcode_hits = 0;

        opcode_bins_hit = 0;


        // Day 10 cross coverage initialization

        cross_bins_hit = 0;

        for (k = 0; k < 16; k = k + 1)

            opcode_hits[k] = 0;

        for (k = 0; k < 250; k = k + 1)

            cross_hits[k] = 0;


        // Initialize inputs

        a = 32'b0;
        b = 32'b0;
        opcode = 4'b0;


        $display("========================================");
        $display("DAY 10: ADVANCED ALU COVERAGE TEST");
        $display("========================================");


        // =====================================
        // PHASE 1: ADD CORNER CASES
        // =====================================

        $display("\n--- ADD CORNER CASES ---");

        check_operation(
            4'h0, 32'h00000000, 32'h00000000
        );

        check_operation(
            4'h0, 32'hFFFFFFFF, 32'h00000001
        );

        check_operation(
            4'h0, 32'h7FFFFFFF, 32'h00000001
        );

        check_operation(
            4'h0, 32'h80000000, 32'h80000000
        );


        // =====================================
        // PHASE 2: SUB CORNER CASES
        // =====================================

        $display("\n--- SUB CORNER CASES ---");

        check_operation(
            4'h1, 32'h00000000, 32'h00000000
        );

        check_operation(
            4'h1, 32'h00000003, 32'h00000005
        );

        check_operation(
            4'h1, 32'h80000000, 32'h00000001
        );

        check_operation(
            4'h1, 32'h7FFFFFFF, 32'hFFFFFFFF
        );


        // =====================================
        // PHASE 3: SLL CORNER CASES
        // =====================================

        $display("\n--- SLL CORNER CASES ---");

        check_operation(
            4'h6, 32'h00000001, 32'h00000000
        );

        check_operation(
            4'h6, 32'h00000001, 32'h0000001F
        );

        check_operation(
            4'h6, 32'h80000001, 32'h00000001
        );

        check_operation(
            4'h6, 32'hAAAAAAAA, 32'h0000001F
        );


        // =====================================
        // PHASE 4: SRL CORNER CASES
        // =====================================

        $display("\n--- SRL CORNER CASES ---");

        check_operation(
            4'h7, 32'h80000000, 32'h00000001
        );

        check_operation(
            4'h7, 32'hFFFFFFFF, 32'h0000001F
        );

        check_operation(
            4'h7, 32'h00000001, 32'h00000001
        );

        check_operation(
            4'h7, 32'hAAAAAAAA, 32'h00000000
        );


        // =====================================
        // PHASE 5: SLT SIGNED COMPARISON
        // =====================================

        $display("\n--- SLT SIGNED COMPARISON ---");

        check_operation(
            4'h8, 32'hFFFFFFFF, 32'h00000001
        );

        check_operation(
            4'h8, 32'h80000000, 32'h7FFFFFFF
        );

        check_operation(
            4'h8, 32'h7FFFFFFF, 32'h80000000
        );

        check_operation(
            4'h8, 32'h00000005, 32'h00000005
        );


        // =====================================
        // PHASE 6: SLTU UNSIGNED COMPARISON
        // =====================================

        $display("\n--- SLTU UNSIGNED COMPARISON ---");

        check_operation(
            4'h9, 32'hFFFFFFFF, 32'h00000001
        );

        check_operation(
            4'h9, 32'h00000001, 32'hFFFFFFFF
        );

        check_operation(
            4'h9, 32'h00000000, 32'h00000000
        );

        check_operation(
            4'h9, 32'h00000005, 32'h00000005
        );


        // =====================================
        // PHASE 7: LOGICAL CORNER CASES
        // =====================================

        $display("\n--- LOGICAL CORNER CASES ---");

        check_operation(
            4'h2, 32'hFFFFFFFF, 32'h00000000
        );

        check_operation(
            4'h3, 32'hF0F0F0F0, 32'h0F0F0F0F
        );

        check_operation(
            4'h4, 32'hAAAAAAAA, 32'hAAAAAAAA
        );

        check_operation(
            4'h5, 32'h00000000, 32'hFFFFFFFF
        );


        // =====================================
        // PHASE 8: INVALID OPCODE TESTS
        // =====================================

        $display("\n--- INVALID OPCODE TESTS ---");

        for (i = 10; i < 16; i = i + 1) begin

            check_operation(
                i[3:0],
                32'hAAAAAAAA,
                32'h55555555
            );

        end


        // =====================================
        // PHASE 9: CROSS COVERAGE TESTS
        // =====================================

        $display("\n========================================");
        $display("DAY 10: CROSS COVERAGE TESTS");
        $display("========================================");

        for (
            opcode_loop = 0;
            opcode_loop < 10;
            opcode_loop = opcode_loop + 1
        ) begin

            for (ca = 0; ca < 5; ca = ca + 1) begin

                for (cb = 0; cb < 5; cb = cb + 1) begin

                    check_operation(

                        opcode_loop[3:0],

                        operand_value(ca),

                        operand_value(cb)

                    );

                end

            end

        end


        // =====================================
        // PHASE 10: OPCODE COVERAGE REPORT
        // =====================================

        $display("\n========================================");
        $display("OPCODE FUNCTIONAL COVERAGE");
        $display("========================================");

        opcode_bins_hit = 0;

        for (k = 0; k < 16; k = k + 1) begin

            $display(
                "Opcode %h : Hits = %0d",
                k,
                opcode_hits[k]
            );

            if (opcode_hits[k] > 0)

                opcode_bins_hit = opcode_bins_hit + 1;

        end

        $display(
            "OPCODE COVERAGE = %0d / 16",
            opcode_bins_hit
        );


        // =====================================
        // PHASE 11: OPERAND COVERAGE REPORT
        // =====================================

        $display("\n========================================");
        $display("OPERAND FUNCTIONAL COVERAGE");
        $display("========================================");

        $display(
            "ZERO OPERAND HITS = %0d",
            zero_operand_hits
        );

        $display(
            "ALL ONES HITS = %0d",
            all_ones_hits
        );

        $display(
            "SIGN BOUNDARY HITS = %0d",
            sign_boundary_hits
        );


        // =====================================
        // PHASE 12: SHIFT COVERAGE REPORT
        // =====================================

        $display("\n========================================");
        $display("SHIFT FUNCTIONAL COVERAGE");
        $display("========================================");

        $display(
            "SHIFT AMOUNT 0 HITS = %0d",
            shift_zero_hits
        );

        $display(
            "SHIFT AMOUNT 1 HITS = %0d",
            shift_one_hits
        );

        $display(
            "SHIFT AMOUNT 31 HITS = %0d",
            shift_max_hits
        );


        // =====================================
        // PHASE 13: FLAG COVERAGE REPORT
        // =====================================

        $display("\n========================================");
        $display("FLAG FUNCTIONAL COVERAGE");
        $display("========================================");

        $display("CARRY HITS = %0d", carry_hits);

        $display("OVERFLOW HITS = %0d", overflow_hits);

        $display("ZERO RESULT HITS = %0d", zero_result_hits);

        $display(
            "INVALID OPCODE HITS = %0d",
            invalid_opcode_hits
        );


        // =====================================
        // PHASE 14: CROSS COVERAGE REPORT
        // =====================================

        $display("\n========================================");
        $display("DAY 10 CROSS COVERAGE REPORT");
        $display("========================================");

        cross_bins_hit = 0;

        for (k = 0; k < 250; k = k + 1) begin

            if (cross_hits[k] > 0)

                cross_bins_hit = cross_bins_hit + 1;

        end

        $display("TOTAL CROSS BINS = 250");

        $display(
            "COVERED CROSS BINS = %0d",
            cross_bins_hit
        );

        $display(
            "MISSING CROSS BINS = %0d",
            250 - cross_bins_hit
        );

        $display(
            "CROSS COVERAGE = %0d / 250",
            cross_bins_hit
        );


        // =====================================
        // PHASE 15: FINAL VERIFICATION SUMMARY
        // =====================================

        $display("\n========================================");
        $display("DAY 10 VERIFICATION SUMMARY");
        $display("========================================");

        $display("DAY 9 DIRECTED TESTS = 34");

        $display("DAY 10 CROSS TESTS = 250");

        $display(
            "TOTAL TESTS = %0d",
            pass_count + fail_count
        );

        $display("TOTAL PASS = %0d", pass_count);

        $display("TOTAL FAIL = %0d", fail_count);

        $display(
            "ASSERTION CHECKS = %0d",
            assertion_check_count
        );

        $display(
            "ASSERTION FAILURES = %0d",
            assertion_fail_count
        );

        $display(
            "OPCODE COVERAGE = %0d / 16",
            opcode_bins_hit
        );

        $display(
            "CROSS COVERAGE = %0d / 250",
            cross_bins_hit
        );


        if (
            fail_count == 0 &&
            assertion_fail_count == 0 &&
            opcode_bins_hit == 16 &&
            cross_bins_hit == 250
        )

            $display("DAY 10 VERIFICATION PASSED");

        else

            $display("DAY 10 VERIFICATION FAILED");


        $display("========================================");

        $finish;

    end

endmodule

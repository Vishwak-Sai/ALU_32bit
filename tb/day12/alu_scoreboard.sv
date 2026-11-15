
`timescale 1ns/1ps

// =====================================================
// DAY 12 - TASK 5
// ALU SCOREBOARD
// =====================================================

class alu_scoreboard;

    // -----------------------------------------
    // 1. MONITOR-TO-SCOREBOARD MAILBOX
    // -----------------------------------------

    mailbox #(alu_transaction) mon2scb;


    // -----------------------------------------
    // 2. SCOREBOARD COUNTERS
    // -----------------------------------------

    int total_count;

    int passed_count;

    int failed_count;


    // -----------------------------------------
    // 3. CONSTRUCTOR
    // -----------------------------------------

    function new(mailbox #(alu_transaction) mbx);

        mon2scb = mbx;

        total_count = 0;

        passed_count = 0;

        failed_count = 0;

    endfunction


    // -----------------------------------------
    // 4. REFERENCE MODEL AND CHECKER
    // -----------------------------------------

    function void check_transaction(
        alu_transaction trans
    );

        logic [32:0] expected_ext;

        logic [31:0] exp_result;

        logic exp_zero;

        logic exp_carry;

        logic exp_overflow;

        logic exp_valid;

        bit transaction_pass;


        // Default expected values

        expected_ext = 33'b0;

        exp_result = 32'b0;

        exp_zero = 1'b0;

        exp_carry = 1'b0;

        exp_overflow = 1'b0;

        exp_valid = 1'b0;


        // =====================================
        // REFERENCE MODEL
        // =====================================

        case (trans.opcode)

            // ADD
            4'h0: begin

                exp_valid = 1'b1;

                expected_ext =
                    {1'b0, trans.a} +
                    {1'b0, trans.b};

                exp_result = expected_ext[31:0];

                exp_carry = expected_ext[32];

                exp_overflow =
                    ~(trans.a[31] ^ trans.b[31]) &
                    (exp_result[31] ^ trans.a[31]);

            end


            // SUB
            4'h1: begin

                exp_valid = 1'b1;

                expected_ext =
                    {1'b0, trans.a} -
                    {1'b0, trans.b};

                exp_result = expected_ext[31:0];

                exp_carry = ~expected_ext[32];

                exp_overflow =
                    (trans.a[31] ^ trans.b[31]) &
                    (exp_result[31] ^ trans.a[31]);

            end


            // AND
            4'h2: begin

                exp_valid = 1'b1;

                exp_result = trans.a & trans.b;

            end


            // OR
            4'h3: begin

                exp_valid = 1'b1;

                exp_result = trans.a | trans.b;

            end


            // XOR
            4'h4: begin

                exp_valid = 1'b1;

                exp_result = trans.a ^ trans.b;

            end


            // NOT
            4'h5: begin

                exp_valid = 1'b1;

                exp_result = ~trans.a;

            end


            // SLL
            4'h6: begin

                exp_valid = 1'b1;

                exp_result = trans.a << trans.b[4:0];

            end


            // SRL
            4'h7: begin

                exp_valid = 1'b1;

                exp_result = trans.a >> trans.b[4:0];

            end


            // SLT - SIGNED
            4'h8: begin

                exp_valid = 1'b1;

                exp_result =
                    ($signed(trans.a) < $signed(trans.b))
                    ? 32'd1 : 32'd0;

            end


            // SLTU - UNSIGNED
            4'h9: begin

                exp_valid = 1'b1;

                exp_result =
                    (trans.a < trans.b)
                    ? 32'd1 : 32'd0;

            end


            // INVALID OPCODES
            default: begin

                exp_valid = 1'b0;

                exp_result = 32'b0;

                exp_carry = 1'b0;

                exp_overflow = 1'b0;

            end

        endcase


        // =====================================
        // ZERO FLAG
        // =====================================

        exp_zero = exp_valid && (exp_result == 32'b0);


        // =====================================
        // STORE EXPECTED VALUES
        // =====================================

        trans.expected_result = exp_result;

        trans.expected_zero = exp_zero;

        trans.expected_carry = exp_carry;

        trans.expected_overflow = exp_overflow;

        trans.expected_valid = exp_valid;


        // =====================================
        // COMPARE EXPECTED AND ACTUAL
        // =====================================

        transaction_pass = 1'b1;


        // RESULT CHECK

        if (trans.actual_result !== exp_result) begin

            transaction_pass = 1'b0;

            $display(
                "RESULT MISMATCH: EXPECTED=%h ACTUAL=%h",
                exp_result,
                trans.actual_result
            );

        end


        // ZERO CHECK

        if (trans.actual_zero !== exp_zero) begin

            transaction_pass = 1'b0;

            $display(
                "ZERO MISMATCH: EXPECTED=%b ACTUAL=%b",
                exp_zero,
                trans.actual_zero
            );

        end


        // CARRY CHECK

        if (trans.actual_carry !== exp_carry) begin

            transaction_pass = 1'b0;

            $display(
                "CARRY MISMATCH: EXPECTED=%b ACTUAL=%b",
                exp_carry,
                trans.actual_carry
            );

        end


        // OVERFLOW CHECK

        if (trans.actual_overflow !== exp_overflow) begin

            transaction_pass = 1'b0;

            $display(
                "OVERFLOW MISMATCH: EXPECTED=%b ACTUAL=%b",
                exp_overflow,
                trans.actual_overflow
            );

        end


        // VALID CHECK

        if (trans.actual_valid !== exp_valid) begin

            transaction_pass = 1'b0;

            $display(
                "VALID MISMATCH: EXPECTED=%b ACTUAL=%b",
                exp_valid,
                trans.actual_valid
            );

        end


        // =====================================
        // UPDATE SCOREBOARD COUNTERS
        // =====================================

        total_count++;


        if (transaction_pass) begin

            passed_count++;

            $display(
                "PASS: ID=%0d OP=%h EXPECTED=%h ACTUAL=%h",
                trans.transaction_id,
                trans.opcode,
                exp_result,
                trans.actual_result
            );

        end

        else begin

            failed_count++;

            $display(
                "FAIL: ID=%0d OP=%h A=%h B=%h",
                trans.transaction_id,
                trans.opcode,
                trans.a,
                trans.b
            );

        end

    endfunction


    // =====================================
    // 5. SCOREBOARD RUN TASK
    // =====================================

    task run(input int number_of_transactions);

        alu_transaction trans;

        $display("\n================================");

        $display("ALU SCOREBOARD STARTED");

        $display("================================");


        repeat (number_of_transactions) begin

            // Receive monitor transaction

            mon2scb.get(trans);


            // Check transaction

            check_transaction(trans);

        end


        // =====================================
        // FINAL SUMMARY
        // =====================================

        $display("\n================================");

        $display("DAY 12 SCOREBOARD SUMMARY");

        $display("================================");

        $display(
            "TOTAL CHECKED = %0d",
            total_count
        );

        $display(
            "TOTAL PASS = %0d",
            passed_count
        );

        $display(
            "TOTAL FAIL = %0d",
            failed_count
        );

        $display("================================");


        if (
            failed_count == 0 &&
            total_count == number_of_transactions
        )

            $display("SCOREBOARD VERIFICATION PASSED");

        else

            $display("SCOREBOARD VERIFICATION FAILED");


        $display("================================");

    endtask

endclass

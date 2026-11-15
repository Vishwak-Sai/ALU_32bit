
`timescale 1ns/1ps

// =============================================
// DAY 12 - TASK 1
// TRANSACTION SMOKE TEST
// =============================================

module transaction_smoke_tb;

    // Transaction object declaration
    alu_transaction trans;

    initial begin

        $display("\n================================");

        $display("DAY 12 TRANSACTION SMOKE TEST");

        $display("================================");


        // -------------------------------------
        // STEP 1: CREATE TRANSACTION
        // -------------------------------------

        trans = new();


        // -------------------------------------
        // STEP 2: ASSIGN TRANSACTION ID
        // -------------------------------------

        trans.transaction_id = 1;


        // -------------------------------------
        // STEP 3: ASSIGN ADD INPUTS
        // -------------------------------------

        trans.opcode = 4'h0;

        trans.a = 32'h00000005;

        trans.b = 32'h00000003;


        // -------------------------------------
        // STEP 4: ASSIGN EXPECTED OUTPUTS
        // -------------------------------------

        trans.expected_result = 32'h00000008;

        trans.expected_zero = 0;

        trans.expected_carry = 0;

        trans.expected_overflow = 0;

        trans.expected_valid = 1;


        // -------------------------------------
        // STEP 5: DISPLAY TRANSACTION
        // -------------------------------------

        trans.display();


        // -------------------------------------
        // STEP 6: REPORT TEST RESULT
        // -------------------------------------

        if (
            trans.opcode == 4'h0 &&
            trans.a == 32'h00000005 &&
            trans.b == 32'h00000003 &&
            trans.expected_result == 32'h00000008 &&
            trans.expected_valid == 1
        )

            $display("TRANSACTION SMOKE TEST PASSED");

        else

            $display("TRANSACTION SMOKE TEST FAILED");


        $display("================================");

        $finish;

    end

endmodule

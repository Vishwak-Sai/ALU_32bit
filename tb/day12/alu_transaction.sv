
`timescale 1ns/1ps

// =====================================================
// DAY 12 - TRANSACTION CLASS
// Updated for Scoreboard Integration
// =====================================================

class alu_transaction;

    // -----------------------------------------
    // 1. INPUT TRANSACTION FIELDS
    // -----------------------------------------

    rand bit [3:0] opcode;

    rand bit [31:0] a;

    rand bit [31:0] b;


    // -----------------------------------------
    // 2. EXPECTED OUTPUT FIELDS
    // -----------------------------------------

    logic [31:0] expected_result;

    logic expected_zero;

    logic expected_carry;

    logic expected_overflow;

    logic expected_valid;


    // -----------------------------------------
    // 3. ACTUAL OUTPUT FIELDS
    // -----------------------------------------

    logic [31:0] actual_result;

    logic actual_zero;

    logic actual_carry;

    logic actual_overflow;

    logic actual_valid;


    // -----------------------------------------
    // 4. TRANSACTION ID
    // -----------------------------------------

    int transaction_id;


    // -----------------------------------------
    // 5. CONSTRUCTOR
    // -----------------------------------------

    function new();

        transaction_id = 0;

        // Initialize inputs

        opcode = 4'h0;

        a = 32'h00000000;

        b = 32'h00000000;


        // Initialize expected outputs

        expected_result = 32'h00000000;

        expected_zero = 1'b0;

        expected_carry = 1'b0;

        expected_overflow = 1'b0;

        expected_valid = 1'b0;


        // Initialize actual outputs

        actual_result = 32'h00000000;

        actual_zero = 1'b0;

        actual_carry = 1'b0;

        actual_overflow = 1'b0;

        actual_valid = 1'b0;

    endfunction


    // -----------------------------------------
    // 6. DISPLAY FUNCTION
    // -----------------------------------------

    function void display();

        $display("--------------------------------");

        $display("TRANSACTION ID = %0d", transaction_id);

        $display("OPCODE          = %h", opcode);

        $display("OPERAND A       = %h", a);

        $display("OPERAND B       = %h", b);

        $display("EXPECTED RESULT = %h", expected_result);

        $display("EXPECTED ZERO   = %b", expected_zero);

        $display("EXPECTED CARRY  = %b", expected_carry);

        $display("EXPECTED OVERFLOW = %b", expected_overflow);

        $display("EXPECTED VALID  = %b", expected_valid);

        $display("ACTUAL RESULT   = %h", actual_result);

        $display("ACTUAL ZERO     = %b", actual_zero);

        $display("ACTUAL CARRY    = %b", actual_carry);

        $display("ACTUAL OVERFLOW = %b", actual_overflow);

        $display("ACTUAL VALID    = %b", actual_valid);

        $display("--------------------------------");

    endfunction

endclass

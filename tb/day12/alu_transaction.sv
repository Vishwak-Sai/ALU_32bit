
class alu_transaction;

    // =====================================
    // 1. TRANSACTION INPUT FIELDS
    // =====================================

    rand bit [3:0] opcode;

    rand bit [31:0] a;
    rand bit [31:0] b;


    // =====================================
    // 2. EXPECTED OUTPUT FIELDS
    // =====================================

    bit [31:0] expected_result;

    bit expected_zero;
    bit expected_carry;
    bit expected_overflow;
    bit expected_valid;


    // =====================================
    // 3. ACTUAL OUTPUT FIELDS
    // =====================================

    bit [31:0] actual_result;

    bit actual_zero;
    bit actual_carry;
    bit actual_overflow;
    bit actual_valid;


    // =====================================
    // 4. TRANSACTION ID
    // =====================================

    int transaction_id;


    // =====================================
    // 5. CONSTRUCTOR
    // =====================================

    function new();

        transaction_id = 0;

        opcode = 0;
        a = 0;
        b = 0;

        expected_result = 0;

        expected_zero = 0;
        expected_carry = 0;
        expected_overflow = 0;
        expected_valid = 0;

        actual_result = 0;

        actual_zero = 0;
        actual_carry = 0;
        actual_overflow = 0;
        actual_valid = 0;

    endfunction


    // =====================================
    // 6. DISPLAY TRANSACTION
    // =====================================

    function void display();

        $display("--------------------------------");

        $display(
            "TRANSACTION ID = %0d",
            transaction_id
        );

        $display(
            "OPCODE = %h",
            opcode
        );

        $display(
            "OPERAND A = %h",
            a
        );

        $display(
            "OPERAND B = %h",
            b
        );

        $display(
            "EXPECTED RESULT = %h",
            expected_result
        );

        $display(
            "EXPECTED ZERO = %b",
            expected_zero
        );

        $display(
            "EXPECTED CARRY = %b",
            expected_carry
        );

        $display(
            "EXPECTED OVERFLOW = %b",
            expected_overflow
        );

        $display(
            "EXPECTED VALID = %b",
            expected_valid
        );

        $display("--------------------------------");

    endfunction

endclass

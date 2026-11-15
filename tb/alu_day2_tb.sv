
`timescale 1ns/1ps

module alu_day2_tb;

    // Inputs
    logic [31:0] a;
    logic [31:0] b;
    logic [3:0] opcode;

    // Outputs
    logic [31:0] result;
    logic zero;
    logic carry;
    logic overflow;
    logic valid;

    integer pass_count;
    integer fail_count;
    integer i;

    // DUT: Device Under Test
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

    // Test task
    task automatic check_opcode(
        input logic [3:0] test_opcode,
        input logic expected_valid
    );

        begin

            opcode = test_opcode;

            #1;

            if (valid !== expected_valid) begin

                $display(
                    "FAIL: Opcode=%h Expected valid=%b Actual valid=%b",
                    test_opcode, expected_valid, valid
                );

                fail_count = fail_count + 1;

            end
            else if (!expected_valid &&
                     (result !== 32'b0 ||
                      zero !== 1'b0 ||
                      carry !== 1'b0 ||
                      overflow !== 1'b0)) begin

                $display(
                    "FAIL: Invalid opcode=%h produced incorrect outputs",
                    test_opcode
                );

                fail_count = fail_count + 1;

            end
            else begin

                $display(
                    "PASS: Opcode=%h Valid=%b",
                    test_opcode, valid
                );

                pass_count = pass_count + 1;

            end

        end

    endtask

    // Main test sequence
    initial begin

        a = 32'd10;
        b = 32'd5;
        opcode = 4'h0;

        pass_count = 0;
        fail_count = 0;

        $display("--------------------------------");
        $display("DAY 2: ALU OPCODE DECODER TEST");
        $display("--------------------------------");

        // Test all 16 opcodes
        for (i = 0; i < 16; i = i + 1) begin

            check_opcode(i, (i <= 9));

        end

        $display("--------------------------------");
        $display("TOTAL PASS = %0d", pass_count);
        $display("TOTAL FAIL = %0d", fail_count);
        $display("--------------------------------");

        if (fail_count == 0)
            $display("DAY 2 DECODER TEST PASSED");
        else
            $display("DAY 2 DECODER TEST FAILED");

        $finish;

    end

endmodule

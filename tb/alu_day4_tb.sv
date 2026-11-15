`timescale 1ns/1ps


module alu_day4_tb;

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

// DUT instantiation
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

// Logical verification task
task automatic check_logic(
input logic [3:0]  test_opcode,
input logic [31:0] test_a,
input logic [31:0] test_b,
input logic [31:0] expected_result
);

logic expected_zero;

begin

a = test_a;
b = test_b;
opcode = test_opcode;

expected_zero = (expected_result == 32'b0);

#1;

if (
result   !== expected_result ||
zero     !== expected_zero ||
carry    !== 1'b0 ||
overflow !== 1'b0 ||
valid    !== 1'b1
) begin

$display("--------------------------------");
$display("FAIL");
$display("Opcode          = %h", test_opcode);
$display("A               = %h", test_a);
$display("B               = %h", test_b);
$display("Expected Result = %h", expected_result);
$display("Actual Result   = %h", result);
$display("Expected Zero   = %b", expected_zero);
$display("Actual Zero     = %b", zero);
$display("Carry           = %b", carry);
$display("Overflow        = %b", overflow);
$display("Valid           = %b", valid);

fail_count = fail_count + 1;

end

else begin

$display(
"PASS: OP=%h A=%h B=%h RESULT=%h ZERO=%b",
test_opcode,
test_a,
test_b,
result,
zero
);

pass_count = pass_count + 1;

end

end

endtask

// Main test sequence
initial begin

$dumpfile("alu_day4.vcd");
$dumpvars(0, alu_day4_tb);

pass_count = 0;
fail_count = 0;

a = 32'b0;
b = 32'b0;
opcode = 4'h2;

$display("====================================");
$display("DAY 4: ALU LOGICAL OPERATION TEST");
$display("====================================");

// AND TESTS

$display("\n--- AND TESTS ---");

check_logic(
4'h2,
32'hF0F0F0F0,
32'h0FF00FF0,
32'h00F000F0
);

check_logic(
4'h2,
32'hFFFFFFFF,
32'hAAAAAAAA,
32'hAAAAAAAA
);

check_logic(
4'h2,
32'h00000000,
32'hFFFFFFFF,
32'h00000000
);

// OR TESTS

$display("\n--- OR TESTS ---");

check_logic(
4'h3,
32'h0F0F0F0F,
32'hF0F0F0F0,
32'hFFFFFFFF
);

check_logic(
4'h3,
32'h00000000,
32'hAAAAAAAA,
32'hAAAAAAAA
);

// XOR TESTS

$display("\n--- XOR TESTS ---");

check_logic(
4'h4,
32'hFFFFFFFF,
32'hAAAAAAAA,
32'h55555555
);

check_logic(
4'h4,
32'hAAAAAAAA,
32'hAAAAAAAA,
32'h00000000
);

// NOT TESTS

$display("\n--- NOT TESTS ---");

check_logic(
4'h5,
32'h00000000,
32'h12345678,
32'hFFFFFFFF
);

check_logic(
4'h5,
32'hFFFFFFFF,
32'h00000000,
32'h00000000
);

check_logic(
4'h5,
32'hAAAAAAAA,
32'h55555555,
32'h55555555
);

// FINAL SUMMARY

$display("\n====================================");
$display("DAY 4 VERIFICATION SUMMARY");
$display("====================================");

$display("TOTAL TESTS = %0d", pass_count + fail_count);
$display("TOTAL PASS  = %0d", pass_count);
$display("TOTAL FAIL  = %0d", fail_count);

if (fail_count == 0)
$display("DAY 4 TEST PASSED");
else
$display("DAY 4 TEST FAILED");

$display("====================================");

$finish;

end

endmodule
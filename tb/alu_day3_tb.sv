`timescale 1ns/1ps


module alu_day3_tb;

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

// Arithmetic verification task
task automatic check_arith(
input logic [3:0]  test_opcode,
input logic [31:0] test_a,
input logic [31:0] test_b,
input logic [31:0] expected_result,
input logic        expected_carry,
input logic        expected_overflow,
input logic        expected_zero
);

begin

a = test_a;
b = test_b;
opcode = test_opcode;

#1;

if (
result   !== expected_result ||
carry    !== expected_carry ||
overflow !== expected_overflow ||
zero     !== expected_zero ||
valid    !== 1'b1
) begin

$display("--------------------------------");
$display("FAIL");
$display("Opcode          = %h", test_opcode);
$display("A               = %h", test_a);
$display("B               = %h", test_b);
$display("Expected Result = %h", expected_result);
$display("Actual Result   = %h", result);
$display("Expected Carry  = %b", expected_carry);
$display("Actual Carry    = %b", carry);
$display("Expected OVF    = %b", expected_overflow);
$display("Actual OVF      = %b", overflow);
$display("Expected Zero   = %b", expected_zero);
$display("Actual Zero     = %b", zero);

fail_count = fail_count + 1;

end

else begin

$display(
"PASS: OP=%h A=%h B=%h RESULT=%h C=%b OVF=%b Z=%b",
test_opcode,
test_a,
test_b,
result,
carry,
overflow,
zero
);

pass_count = pass_count + 1;

end

end

endtask

// Main test sequence
initial begin

$dumpfile("alu_day3.vcd");
$dumpvars(0, alu_day3_tb);

pass_count = 0;
fail_count = 0;

a = 32'b0;
b = 32'b0;
opcode = 4'h0;

$display("====================================");
$display("DAY 3: ALU ADD AND SUB VERIFICATION");
$display("====================================");

// ADD TESTS

$display("\n--- ADD TESTS ---");

check_arith(
4'h0, 32'd10, 32'd5,
32'd15, 1'b0, 1'b0, 1'b0
);

check_arith(
4'h0, 32'd0, 32'd0,
32'd0, 1'b0, 1'b0, 1'b1
);

check_arith(
4'h0, 32'hFFFFFFFF, 32'h00000001,
32'h00000000, 1'b1, 1'b0, 1'b1
);

check_arith(
4'h0, 32'h7FFFFFFF, 32'h00000001,
32'h80000000, 1'b0, 1'b1, 1'b0
);

check_arith(
4'h0, 32'h80000000, 32'h80000000,
32'h00000000, 1'b1, 1'b1, 1'b1
);

// SUB TESTS

$display("\n--- SUB TESTS ---");

check_arith(
4'h1, 32'd10, 32'd5,
32'd5, 1'b1, 1'b0, 1'b0
);

check_arith(
4'h1, 32'd3, 32'd5,
32'hFFFFFFFE, 1'b0, 1'b0, 1'b0
);

check_arith(
4'h1, 32'd0, 32'd1,
32'hFFFFFFFF, 1'b0, 1'b0, 1'b0
);

check_arith(
4'h1, 32'd5, 32'd5,
32'd0, 1'b1, 1'b0, 1'b1
);

check_arith(
4'h1, 32'h80000000, 32'h00000001,
32'h7FFFFFFF, 1'b1, 1'b1, 1'b0
);

check_arith(
4'h1, 32'h7FFFFFFF, 32'hFFFFFFFF,
32'h80000000, 1'b0, 1'b1, 1'b0
);

// FINAL SUMMARY

$display("\n====================================");
$display("DAY 3 VERIFICATION SUMMARY");
$display("====================================");

$display("TOTAL TESTS = %0d", pass_count + fail_count);
$display("TOTAL PASS  = %0d", pass_count);
$display("TOTAL FAIL  = %0d", fail_count);

if (fail_count == 0)
$display("DAY 3 TEST PASSED");
else
$display("DAY 3 TEST FAILED");

$display("====================================");

$finish;

end

endmodule
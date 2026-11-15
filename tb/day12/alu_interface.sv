
`timescale 1ns/1ps

interface alu_if;

    logic [31:0] a;
    logic [31:0] b;
    logic [3:0] opcode;

    logic [31:0] result;
    logic zero;
    logic carry;
    logic overflow;
    logic valid;

endinterface

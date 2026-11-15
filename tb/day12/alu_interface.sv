
`timescale 1ns/1ps

interface alu_if;

    // DUT inputs
    logic [31:0] a;
    logic [31:0] b;
    logic [3:0] opcode;

    // DUT outputs
    logic [31:0] result;
    logic zero;
    logic carry;
    logic overflow;
    logic valid;

    // Testbench synchronization
    logic sample;

    // Transaction identification
    logic [31:0] transaction_id;

endinterface


`timescale 1ns/1ps

// =============================================
// DAY 12 - TASK 4
// ALU INTERFACE
// =============================================

interface alu_if;

    // DUT input signals

    logic [31:0] a;
    logic [31:0] b;
    logic [3:0] opcode;

    // DUT output signals

    logic [31:0] result;

    logic zero;
    logic carry;
    logic overflow;
    logic valid;

    // Testbench synchronization signals

    logic sample;

    logic [31:0] transaction_id;

endinterface

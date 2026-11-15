`timescale 1ns/1ps


// =====================================================
// DAY 12 - TASK 5
// SCOREBOARD SMOKE TEST
// =====================================================

module scoreboard_smoke_tb;

// -----------------------------------------
// 1. TEST CONFIGURATION
// -----------------------------------------

localparam int TOTAL_TRANSACTIONS = 30;

// -----------------------------------------
// 2. ALU INTERFACE
// -----------------------------------------

alu_if alu_bus();

// -----------------------------------------
// 3. MAILBOXES
// -----------------------------------------

mailbox #(alu_transaction) gen2drv;

mailbox #(alu_transaction) mon2scb;

// -----------------------------------------
// 4. VERIFICATION COMPONENTS
// -----------------------------------------

alu_generator gen;

alu_driver drv;

alu_monitor mon;

alu_scoreboard scb;

// -----------------------------------------
// 5. DUT INSTANTIATION
// -----------------------------------------

alu_32bit dut (

.a(alu_bus.a),

.b(alu_bus.b),

.opcode(alu_bus.opcode),

.result(alu_bus.result),

.zero(alu_bus.zero),

.carry(alu_bus.carry),

.overflow(alu_bus.overflow),

.valid(alu_bus.valid)

);

// -----------------------------------------
// 6. MAIN TEST
// -----------------------------------------

initial begin

// Enable waveform generation

$dumpfile("alu_day12_scoreboard.vcd");

$dumpvars(0, scoreboard_smoke_tb);

$display("\n================================");

$display("DAY 12 SCOREBOARD SMOKE TEST");

$display("================================");

// Initialize interface

alu_bus.a = 0;

alu_bus.b = 0;

alu_bus.opcode = 0;

alu_bus.sample = 0;

alu_bus.transaction_id = 0;

// Create mailboxes

gen2drv = new();

mon2scb = new();

// Create generator

gen = new(gen2drv);

// Create driver

drv = new(gen2drv, alu_bus);

// Create monitor

mon = new(alu_bus, mon2scb);

// Create scoreboard

scb = new(mon2scb);

// =====================================
// RUN ALL COMPONENTS
// =====================================

fork

// Generator process

gen.run();

// Driver process

drv.run(TOTAL_TRANSACTIONS);

// Monitor process

mon.run(TOTAL_TRANSACTIONS);

// Scoreboard process

scb.run(TOTAL_TRANSACTIONS);

join

// =====================================
// FINAL VERIFICATION SUMMARY
// =====================================

$display("\n================================");

$display("DAY 12 FINAL VERIFICATION SUMMARY");

$display("================================");

$display(
"GENERATED TRANSACTIONS = %0d",
gen.transaction_count
);

$display(
"DRIVEN TRANSACTIONS = %0d",
drv.driven_count
);

$display(
"MONITORED TRANSACTIONS = %0d",
mon.monitored_count
);

$display(
"SCOREBOARD CHECKED = %0d",
scb.total_count
);

$display(
"SCOREBOARD PASS = %0d",
scb.passed_count
);

$display(
"SCOREBOARD FAIL = %0d",
scb.failed_count
);

// =====================================
// FINAL PASS / FAIL
// =====================================

if (

gen.transaction_count == TOTAL_TRANSACTIONS &&

drv.driven_count == TOTAL_TRANSACTIONS &&

mon.monitored_count == TOTAL_TRANSACTIONS &&

scb.total_count == TOTAL_TRANSACTIONS &&

scb.failed_count == 0

)

$display("DAY 12 COMPLETE VERIFICATION PASSED");

else

$display("DAY 12 COMPLETE VERIFICATION FAILED");

$display("================================");

$finish;

end

endmodule
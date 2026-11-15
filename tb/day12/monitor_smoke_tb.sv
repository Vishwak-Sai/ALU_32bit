`timescale 1ns/1ps


// =============================================
// DAY 12 - TASK 4
// MONITOR SMOKE TEST
// =============================================

module monitor_smoke_tb;

// -----------------------------------------
// 1. INTERFACE
// -----------------------------------------

alu_if alu_bus();

// -----------------------------------------
// 2. MAILBOXES
// -----------------------------------------

mailbox #(alu_transaction) gen2drv;

mailbox #(alu_transaction) mon2scb;

// -----------------------------------------
// 3. COMPONENTS
// -----------------------------------------

alu_generator gen;

alu_driver drv;

alu_monitor mon;

// -----------------------------------------
// 4. RECEIVED TRANSACTION
// -----------------------------------------

alu_transaction observed;

int received_count;

// -----------------------------------------
// 5. DUT
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

$dumpfile("alu_day12_monitor.vcd");

$dumpvars(0, monitor_smoke_tb);

$display("\n================================");

$display("DAY 12 MONITOR SMOKE TEST");

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

// Create components

gen = new(gen2drv);

drv = new(gen2drv, alu_bus);

mon = new(alu_bus, mon2scb);

received_count = 0;

// -------------------------------------
// 7. RUN ALL COMPONENTS
// -------------------------------------

fork

// Generator

gen.run();

// Driver

drv.run(20);

// Monitor

mon.run(20);

// Monitor output consumer

begin

repeat (20) begin

mon2scb.get(observed);

received_count++;

$display(
"SCOREBOARD INPUT: ID=%0d RESULT=%h VALID=%b",
observed.transaction_id,
observed.actual_result,
observed.actual_valid
);

end

end

join

// -------------------------------------
// 8. FINAL SUMMARY
// -------------------------------------

$display("\n================================");

$display("DAY 12 MONITOR SMOKE TEST SUMMARY");

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
"RECEIVED OBSERVATIONS = %0d",
received_count
);

if (

gen.transaction_count == 20 &&

drv.driven_count == 20 &&

mon.monitored_count == 20 &&

received_count == 20

)

$display("DAY 12 MONITOR SMOKE TEST PASSED");

else

$display("DAY 12 MONITOR SMOKE TEST FAILED");

$display("================================");

$finish;

end

endmodule
`timescale 1ns/1ps


// =============================================
// DAY 12 - TASK 2
// GENERATOR SMOKE TEST
// =============================================

module generator_smoke_tb;

// -----------------------------------------
// 1. MAILBOX DECLARATION
// -----------------------------------------

mailbox #(alu_transaction) gen2drv;

// -----------------------------------------
// 2. GENERATOR HANDLE
// -----------------------------------------

alu_generator gen;

// -----------------------------------------
// 3. RECEIVED TRANSACTION
// -----------------------------------------

alu_transaction received;

int received_count;

// -----------------------------------------
// 4. MAIN TEST
// -----------------------------------------

initial begin

$display("\n================================");

$display("DAY 12 GENERATOR SMOKE TEST");

$display("================================");

// Create mailbox

gen2drv = new();

// Create generator

gen = new(gen2drv);

// Initialize counter

received_count = 0;

// =====================================
// RUN GENERATOR AND CONSUMER
// =====================================

fork

// Generator process

begin

gen.run();

end

// Consumer process

begin

repeat (20) begin

// Receive transaction

gen2drv.get(received);

received_count = received_count + 1;

// Display received transaction

$display("\n--- RECEIVED TRANSACTION ---");

received.display();

end

end

join

// =====================================
// FINAL SUMMARY
// =====================================

$display("\n================================");

$display("GENERATOR SMOKE TEST SUMMARY");

$display("================================");

$display(
"TOTAL TRANSACTIONS RECEIVED = %0d",
received_count
);

if (received_count == 20)

$display("GENERATOR SMOKE TEST PASSED");

else

$display("GENERATOR SMOKE TEST FAILED");

$display("================================");

$finish;

end

endmodule
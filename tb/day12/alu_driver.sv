`timescale 1ns/1ps


// =============================================
// DAY 12 - TASK 4
// UPDATED ALU DRIVER
// =============================================

class alu_driver;

mailbox #(alu_transaction) gen2drv;

virtual alu_if vif;

int driven_count;

// CONSTRUCTOR

function new(
mailbox #(alu_transaction) mbx,
virtual alu_if vif
);

gen2drv = mbx;

this.vif = vif;

driven_count = 0;

endfunction

// DRIVER TASK

task run(input int number_of_transactions);

alu_transaction trans;

$display("\n================================");

$display("ALU DRIVER STARTED");

$display("================================");

repeat (number_of_transactions) begin

// Receive transaction

gen2drv.get(trans);

// Drive DUT inputs

vif.a = trans.a;

vif.b = trans.b;

vif.opcode = trans.opcode;

vif.transaction_id = trans.transaction_id;

// Wait for combinational settling

#1;

// Notify monitor

vif.sample = 1'b1;

#1;

vif.sample = 1'b0;

driven_count++;

$display(
"DRIVER: ID=%0d OP=%h A=%h B=%h",
trans.transaction_id,
trans.opcode,
trans.a,
trans.b
);

end

$display("\nDRIVER COMPLETED");

$display(
"TOTAL TRANSACTIONS DRIVEN = %0d",
driven_count
);

endtask

endclass
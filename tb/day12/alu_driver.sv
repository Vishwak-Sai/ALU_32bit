`timescale 1ns/1ps


class alu_driver;

// Generator-to-driver mailbox
mailbox #(alu_transaction) gen2drv;

// Virtual interface
virtual alu_if vif;

// Transaction counter
int driven_count;

// Constructor
function new(
mailbox #(alu_transaction) mbx,
virtual alu_if vif
);

gen2drv = mbx;
this.vif = vif;

driven_count = 0;

endfunction

// Driver task
task run(input int number_of_transactions);

alu_transaction trans;

$display("\n================================");
$display("ALU DRIVER STARTED");
$display("================================");

repeat (number_of_transactions) begin

// Receive transaction
gen2drv.get(trans);

// Apply inputs
vif.a = trans.a;
vif.b = trans.b;
vif.opcode = trans.opcode;

// Apply transaction ID
vif.transaction_id = trans.transaction_id;

// Wait for combinational settling
#1;

// Trigger monitor sampling
vif.sample = 1'b1;

#1;

vif.sample = 1'b0;

// Update driver count
driven_count++;

$display(
"DRIVER: ID=%0d OP=%h A=%h B=%h",
trans.transaction_id,
trans.opcode,
trans.a,
trans.b
);

end

$display("\n================================");
$display("DRIVER SUMMARY");
$display("================================");

$display(
"TOTAL TRANSACTIONS DRIVEN = %0d",
driven_count
);

$display("DRIVER COMPLETED");
$display("================================");

endtask

endclass
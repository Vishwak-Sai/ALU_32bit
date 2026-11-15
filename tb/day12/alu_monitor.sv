
`timescale 1ns/1ps

// =============================================
// DAY 12 - TASK 4
// ALU MONITOR
// =============================================

class alu_monitor;

    // -----------------------------------------
    // 1. VIRTUAL INTERFACE
    // -----------------------------------------

    virtual alu_if vif;


    // -----------------------------------------
    // 2. MONITOR TO SCOREBOARD MAILBOX
    // -----------------------------------------

    mailbox #(alu_transaction) mon2scb;


    // -----------------------------------------
    // 3. MONITOR COUNTER
    // -----------------------------------------

    int monitored_count;


    // -----------------------------------------
    // 4. CONSTRUCTOR
    // -----------------------------------------

    function new(
        virtual alu_if vif,
        mailbox #(alu_transaction) mbx
    );

        this.vif = vif;

        mon2scb = mbx;

        monitored_count = 0;

    endfunction


    // -----------------------------------------
    // 5. MONITOR TASK
    // -----------------------------------------

    task run(input int number_of_transactions);

        alu_transaction trans;

        $display("\n================================");

        $display("ALU MONITOR STARTED");

        $display("================================");


        repeat (number_of_transactions) begin

            // Wait for driver sampling pulse

            @(posedge vif.sample);


            // Create observed transaction

            trans = new();


            // Capture transaction ID

            trans.transaction_id =
                vif.transaction_id;


            // Capture DUT inputs

            trans.opcode = vif.opcode;

            trans.a = vif.a;

            trans.b = vif.b;


            // Capture actual DUT outputs

            trans.actual_result = vif.result;

            trans.actual_zero = vif.zero;

            trans.actual_carry = vif.carry;

            trans.actual_overflow = vif.overflow;

            trans.actual_valid = vif.valid;


            // Increment monitor count

            monitored_count++;


            // Display observed transaction

            $display("--------------------------------");

            $display(
                "MONITOR: TRANSACTION ID = %0d",
                trans.transaction_id
            );

            $display(
                "MONITOR: OPCODE = %h",
                trans.opcode
            );

            $display(
                "MONITOR: A = %h",
                trans.a
            );

            $display(
                "MONITOR: B = %h",
                trans.b
            );

            $display(
                "MONITOR: ACTUAL RESULT = %h",
                trans.actual_result
            );

            $display(
                "MONITOR: ZERO = %b",
                trans.actual_zero
            );

            $display(
                "MONITOR: CARRY = %b",
                trans.actual_carry
            );

            $display(
                "MONITOR: OVERFLOW = %b",
                trans.actual_overflow
            );

            $display(
                "MONITOR: VALID = %b",
                trans.actual_valid
            );

            $display("--------------------------------");


            // Send observed transaction to scoreboard

            mon2scb.put(trans);

        end


        // Monitor summary

        $display("\n================================");

        $display("MONITOR SUMMARY");

        $display("================================");

        $display(
            "TOTAL TRANSACTIONS MONITORED = %0d",
            monitored_count
        );

        $display("MONITOR COMPLETED");

        $display("================================");

    endtask

endclass

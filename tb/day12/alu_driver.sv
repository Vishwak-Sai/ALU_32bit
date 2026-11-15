
`timescale 1ns/1ps

// =============================================
// DAY 12 - TASK 3
// ALU DRIVER
// =============================================

class alu_driver;

    // -----------------------------------------
    // 1. MAILBOX
    // -----------------------------------------

    mailbox #(alu_transaction) gen2drv;


    // -----------------------------------------
    // 2. VIRTUAL INTERFACE
    // -----------------------------------------

    virtual alu_if vif;


    // -----------------------------------------
    // 3. DRIVER COUNTER
    // -----------------------------------------

    int driven_count;


    // -----------------------------------------
    // 4. CONSTRUCTOR
    // -----------------------------------------

    function new(
        mailbox #(alu_transaction) mbx,
        virtual alu_if vif
    );

        gen2drv = mbx;

        this.vif = vif;

        driven_count = 0;

    endfunction


    // -----------------------------------------
    // 5. DRIVER TASK
    // -----------------------------------------

    task run(input int number_of_transactions);

        alu_transaction trans;

        $display("\n================================");

        $display("DAY 12 ALU DRIVER STARTED");

        $display("================================");


        repeat (number_of_transactions) begin

            // Receive transaction from generator

            gen2drv.get(trans);


            // Apply inputs to DUT

            vif.a = trans.a;

            vif.b = trans.b;

            vif.opcode = trans.opcode;


            // Wait for combinational settling

            #1;


            // Store actual DUT outputs in transaction

            trans.actual_result = vif.result;

            trans.actual_zero = vif.zero;

            trans.actual_carry = vif.carry;

            trans.actual_overflow = vif.overflow;

            trans.actual_valid = vif.valid;


            driven_count = driven_count + 1;


            // Display driven transaction

            $display("--------------------------------");

            $display(
                "DRIVER: TRANSACTION ID = %0d",
                trans.transaction_id
            );

            $display(
                "DRIVER: OPCODE = %h",
                vif.opcode
            );

            $display(
                "DRIVER: A = %h",
                vif.a
            );

            $display(
                "DRIVER: B = %h",
                vif.b
            );

            $display(
                "DRIVER: RESULT = %h",
                vif.result
            );

            $display(
                "DRIVER: VALID = %b",
                vif.valid
            );

            $display("--------------------------------");

        end


        // Driver summary

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

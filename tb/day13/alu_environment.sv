
`timescale 1ns/1ps

// =====================================================
// DAY 13 - ALU VERIFICATION ENVIRONMENT
// =====================================================

class alu_environment;

    // -----------------------------------------
    // 1. VIRTUAL INTERFACE
    // -----------------------------------------

    virtual alu_if vif;


    // -----------------------------------------
    // 2. MAILBOXES
    // -----------------------------------------

    mailbox #(alu_transaction) gen2drv;

    mailbox #(alu_transaction) mon2scb;


    // -----------------------------------------
    // 3. VERIFICATION COMPONENTS
    // -----------------------------------------

    alu_generator gen;

    alu_driver drv;

    alu_monitor mon;

    alu_scoreboard scb;

    alu_coverage cov;


    // -----------------------------------------
    // 4. CONFIGURATION
    // -----------------------------------------

    int total_transactions;


    // -----------------------------------------
    // 5. CONSTRUCTOR
    // -----------------------------------------

    function new(
        virtual alu_if vif,
        int total_transactions
    );

        this.vif = vif;

        this.total_transactions = total_transactions;

        // Create mailboxes
        gen2drv = new();

        mon2scb = new();

        // Create generator
        gen = new(gen2drv);

        // Create driver
        drv = new(gen2drv, vif);

        // Create functional coverage
        cov = new();

        // Create monitor with coverage connection
        mon = new(vif, mon2scb, cov);

        // Create scoreboard
        scb = new(mon2scb);

    endfunction


    // -----------------------------------------
    // 6. RUN ENVIRONMENT
    // -----------------------------------------

    task run();

        $display("\n================================");

        $display("ALU ENVIRONMENT STARTED");

        $display("================================");


        fork

            // Generator
            gen.run();

            // Driver
            drv.run(total_transactions);

            // Monitor
            mon.run(total_transactions);

            // Scoreboard
            scb.run(total_transactions);

        join


        $display("\n================================");

        $display("ALU ENVIRONMENT COMPLETED");

        $display("================================");

    endtask


    // -----------------------------------------
    // 7. VERIFICATION SUMMARY
    // -----------------------------------------

    function void display_summary();

        $display("\n================================");

        $display("DAY 13 VERIFICATION SUMMARY");

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

        // Display functional coverage
        cov.display_coverage();

        // Final verification status
        if (
            gen.transaction_count == total_transactions &&
            drv.driven_count == total_transactions &&
            mon.monitored_count == total_transactions &&
            scb.total_count == total_transactions &&
            scb.failed_count == 0
        )

            $display("DAY 13 VERIFICATION PASSED");

        else

            $display("DAY 13 VERIFICATION FAILED");

        $display("================================");

    endfunction

endclass

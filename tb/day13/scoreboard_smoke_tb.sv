`timescale 1ns/1ps

// =====================================================
// DAY 13 - ALU FUNCTIONAL COVERAGE TESTBENCH
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
    // 3. ENVIRONMENT HANDLE
    // -----------------------------------------

    alu_environment env;

// -----------------------------------------
    // 4. DUT INSTANTIATION
    // -----------------------------------------

    alu_32bit dut (

        .a        (alu_bus.a),

        .b        (alu_bus.b),

        .opcode   (alu_bus.opcode),

        .result   (alu_bus.result),

        .zero     (alu_bus.zero),

        .carry    (alu_bus.carry),

        .overflow (alu_bus.overflow),

        .valid    (alu_bus.valid)

    );

// -----------------------------------------
    // 5. MAIN TEST
    // -----------------------------------------

    initial begin

        // Enable waveform generation

        $dumpfile("alu_day13_coverage.vcd");

        $dumpvars(0, scoreboard_smoke_tb);

        $display("\n================================");

        $display("DAY 13 FUNCTIONAL COVERAGE TEST");

        $display("================================");

        // Initialize interface

        alu_bus.a = 0;

        alu_bus.b = 0;

        alu_bus.opcode = 0;

        alu_bus.sample = 0;

        alu_bus.transaction_id = 0;

// -------------------------------------
        // CREATE ENVIRONMENT
        // -------------------------------------

env = new(
            alu_bus,
            TOTAL_TRANSACTIONS
        );

// -------------------------------------
        // RUN ENVIRONMENT
        // -------------------------------------

        env.run();

// -------------------------------------
        // DISPLAY VERIFICATION SUMMARY
        // -------------------------------------

        env.display_summary();

// -------------------------------------
        // FINAL RESULT
        // -------------------------------------

        if (

            env.gen.transaction_count == TOTAL_TRANSACTIONS &&

            env.drv.driven_count == TOTAL_TRANSACTIONS &&

            env.mon.monitored_count == TOTAL_TRANSACTIONS &&

            env.scb.total_count == TOTAL_TRANSACTIONS &&

            env.scb.failed_count == 0

        )

            $display("\nDAY 13 VERIFICATION PASSED");

        else

            $display("\nDAY 13 VERIFICATION FAILED");

        $display("\n================================");

        $finish;

    end

endmodule
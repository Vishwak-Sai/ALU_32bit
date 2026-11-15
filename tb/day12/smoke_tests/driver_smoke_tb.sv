
`timescale 1ns/1ps

// =============================================
// DAY 12 - TASK 3
// DRIVER SMOKE TEST
// =============================================

module driver_smoke_tb;

    // -----------------------------------------
    // 1. INTERFACE INSTANCE
    // -----------------------------------------

    alu_if alu_bus();


    // -----------------------------------------
    // 2. MAILBOX
    // -----------------------------------------

    mailbox #(alu_transaction) gen2drv;


    // -----------------------------------------
    // 3. GENERATOR AND DRIVER
    // -----------------------------------------

    alu_generator gen;

    alu_driver drv;


    // -----------------------------------------
    // 4. DUT INSTANTIATION
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
    // 5. MAIN TEST
    // -----------------------------------------

    initial begin

        $display("\n================================");

        $display("DAY 12 DRIVER SMOKE TEST");

        $display("================================");


        // Create mailbox

        gen2drv = new();


        // Create generator

        gen = new(gen2drv);


        // Create driver

        drv = new(gen2drv, alu_bus);


        // Initialize interface inputs

        alu_bus.a = 0;

        alu_bus.b = 0;

        alu_bus.opcode = 0;


        // Run generator and driver concurrently

        fork

            gen.run();

            drv.run(20);

        join


        // -------------------------------------
        // FINAL SUMMARY
        // -------------------------------------

        $display("\n================================");

        $display("DAY 12 DRIVER SMOKE TEST SUMMARY");

        $display("================================");

        $display(
            "GENERATED TRANSACTIONS = %0d",
            gen.transaction_count
        );

        $display(
            "DRIVEN TRANSACTIONS = %0d",
            drv.driven_count
        );


        if (

            gen.transaction_count == 20 &&

            drv.driven_count == 20

        )

            $display("DAY 12 DRIVER SMOKE TEST PASSED");

        else

            $display("DAY 12 DRIVER SMOKE TEST FAILED");


        $display("================================");

        $finish;

    end

endmodule

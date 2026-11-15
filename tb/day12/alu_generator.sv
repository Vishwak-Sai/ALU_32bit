
`timescale 1ns/1ps

// =============================================
// DAY 12 - TASK 2
// ALU GENERATOR
// =============================================

class alu_generator;

    // -----------------------------------------
    // 1. MAILBOX
    // -----------------------------------------

    mailbox #(alu_transaction) gen2drv;


    // -----------------------------------------
    // 2. GENERATOR VARIABLES
    // -----------------------------------------

    int transaction_count;

    int directed_count;

    int random_count;

    int transaction_id;


    // -----------------------------------------
    // 3. CONSTRUCTOR
    // -----------------------------------------

    function new(mailbox #(alu_transaction) mbx);

        gen2drv = mbx;

        transaction_count = 0;

        directed_count = 10;

        random_count = 10;

        transaction_id = 0;

    endfunction


    // -----------------------------------------
    // 4. GENERATOR TASK
    // -----------------------------------------

    task run();

        alu_transaction trans;

        $display("\n================================");

        $display("DAY 12 ALU GENERATOR STARTED");

        $display("================================");


        // =====================================
        // PHASE 1: DIRECTED TRANSACTIONS
        // =====================================

        $display("\n--- DIRECTED TRANSACTIONS ---");

        for (int i = 0; i < directed_count; i++) begin

            // Create a new transaction object

            trans = new();

            transaction_id = transaction_id + 1;

            trans.transaction_id = transaction_id;


            // Assign opcode

            trans.opcode = i[3:0];


            // Assign directed operands

            trans.a = 32'h00000005;

            trans.b = 32'h00000003;


            // Send transaction to mailbox

            gen2drv.put(trans);


            transaction_count = transaction_count + 1;


            $display(
                "GENERATOR: Directed transaction %0d generated, OP=%h",
                transaction_id,
                trans.opcode
            );

        end


        // =====================================
        // PHASE 2: RANDOM TRANSACTIONS
        // =====================================

        $display("\n--- RANDOM TRANSACTIONS ---");

        for (int i = 0; i < random_count; i++) begin

            // Create a new transaction object

            trans = new();

            transaction_id = transaction_id + 1;


            // Randomize opcode and operands

            if (!trans.randomize()) begin

                $fatal(1, "Transaction randomization failed");

            end


            // Assign transaction ID

            trans.transaction_id = transaction_id;


            // Send transaction to mailbox

            gen2drv.put(trans);


            transaction_count = transaction_count + 1;


            $display(
                "GENERATOR: Random transaction %0d generated, OP=%h",
                transaction_id,
                trans.opcode
            );

        end


        // =====================================
        // PHASE 3: GENERATOR SUMMARY
        // =====================================

        $display("\n================================");

        $display("GENERATOR SUMMARY");

        $display("================================");

        $display(
            "DIRECTED TRANSACTIONS = %0d",
            directed_count
        );

        $display(
            "RANDOM TRANSACTIONS = %0d",
            random_count
        );

        $display(
            "TOTAL GENERATED = %0d",
            transaction_count
        );

        $display("GENERATOR COMPLETED");

        $display("================================");

    endtask

endclass

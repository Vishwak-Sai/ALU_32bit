
`timescale 1ns/1ps

// =============================================
// DAY 13 - ALU GENERATOR
// 20 DIRECTED + 10 RANDOM TRANSACTIONS
// =============================================

class alu_generator;

    // Mailbox
    mailbox #(alu_transaction) gen2drv;

    // Generator variables
    int transaction_count;
    int directed_count;
    int random_count;
    int transaction_id;

    // Constructor
    function new(mailbox #(alu_transaction) mbx);

        gen2drv = mbx;

        transaction_count = 0;

        directed_count = 20;

        random_count = 10;

        transaction_id = 0;

    endfunction


    // Generator task
    task run();

        alu_transaction trans;

        $display("\n================================");
        $display("DAY 13 ALU GENERATOR STARTED");
        $display("================================");


        // =====================================
        // PHASE 1: DIRECTED TRANSACTIONS
        // =====================================

        $display("\n--- DIRECTED TRANSACTIONS ---");

        for (int i = 0; i < directed_count; i++) begin

            trans = new();

            transaction_id++;

            trans.transaction_id = transaction_id;

            // First 16 transactions exercise opcodes 0-F
            if (i < 16) begin

                trans.opcode = i[3:0];

                trans.a = 32'h00000005;

                trans.b = 32'h00000003;

            end

            // ADD signed overflow
            else if (i == 16) begin

                trans.opcode = 4'h0;

                trans.a = 32'h7FFFFFFF;

                trans.b = 32'h00000001;

            end

            // ADD carry
            else if (i == 17) begin

                trans.opcode = 4'h0;

                trans.a = 32'hFFFFFFFF;

                trans.b = 32'h00000001;

            end

            // SUB borrow
            else if (i == 18) begin

                trans.opcode = 4'h1;

                trans.a = 32'h00000003;

                trans.b = 32'h00000005;

            end

            // SUB signed overflow
            else begin

                trans.opcode = 4'h1;

                trans.a = 32'h80000000;

                trans.b = 32'h00000001;

            end

            // Send transaction
            gen2drv.put(trans);

            transaction_count++;

            $display(
                "GENERATOR: Directed ID=%0d OP=%h A=%h B=%h",
                transaction_id,
                trans.opcode,
                trans.a,
                trans.b
            );

        end


        // =====================================
        // PHASE 2: RANDOM TRANSACTIONS
        // =====================================

        $display("\n--- RANDOM TRANSACTIONS ---");

        for (int i = 0; i < random_count; i++) begin

            trans = new();

            transaction_id++;

            if (!trans.randomize()) begin

                $fatal(1, "Transaction randomization failed");

            end

            trans.transaction_id = transaction_id;

            gen2drv.put(trans);

            transaction_count++;

            $display(
                "GENERATOR: Random ID=%0d OP=%h A=%h B=%h",
                transaction_id,
                trans.opcode,
                trans.a,
                trans.b
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

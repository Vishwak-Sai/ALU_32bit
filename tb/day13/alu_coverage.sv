
`timescale 1ns/1ps

// =====================================================
// DAY 13 - ALU FUNCTIONAL COVERAGE
// =====================================================

class alu_coverage;

    // -----------------------------------------
    // 1. FUNCTIONAL COVERAGE GROUP
    // -----------------------------------------

    covergroup alu_cg with function sample(
        bit [3:0]  opcode,
        bit [31:0] a,
        bit [31:0] b
    );

        // -------------------------------------
        // OPCODE COVERAGE
        // -------------------------------------

        cp_opcode: coverpoint opcode {

            bins ADD  = {4'h0};
            bins SUB  = {4'h1};
            bins AND  = {4'h2};
            bins OR   = {4'h3};
            bins XOR  = {4'h4};
            bins NOT  = {4'h5};
            bins SLL  = {4'h6};
            bins SRL  = {4'h7};
            bins SLT  = {4'h8};
            bins SLTU = {4'h9};

            // Separate bins for A through F
            bins INVALID[] = {[4'hA:4'hF]};
        }

        // -------------------------------------
        // OPERAND A BOUNDARY COVERAGE
        // -------------------------------------

        cp_operand_a: coverpoint a {

            bins ZERO       = {32'h00000000};
            bins ONE        = {32'h00000001};
            bins MAX_SIGNED = {32'h7FFFFFFF};
            bins MIN_SIGNED = {32'h80000000};
            bins ALL_ONES   = {32'hFFFFFFFF};

            bins OTHER = default;
        }

        // -------------------------------------
        // OPERAND B BOUNDARY COVERAGE
        // -------------------------------------

        cp_operand_b: coverpoint b {

            bins ZERO       = {32'h00000000};
            bins ONE        = {32'h00000001};
            bins MAX_SIGNED = {32'h7FFFFFFF};
            bins MIN_SIGNED = {32'h80000000};
            bins ALL_ONES   = {32'hFFFFFFFF};

            bins OTHER = default;
        }

        // -------------------------------------
        // CROSS COVERAGE
        // -------------------------------------

        cross_opcode_a: cross cp_opcode, cp_operand_a;

        cross_opcode_b: cross cp_opcode, cp_operand_b;

    endgroup


    // -----------------------------------------
    // 2. CONSTRUCTOR
    // -----------------------------------------

    function new();

        alu_cg = new();

    endfunction


    // -----------------------------------------
    // 3. SAMPLE TRANSACTION
    // -----------------------------------------

    function void sample_transaction(alu_transaction tr);

        alu_cg.sample(
            tr.opcode,
            tr.a,
            tr.b
        );

    endfunction


    // -----------------------------------------
    // 4. DISPLAY COVERAGE REPORT
    // -----------------------------------------

    function void display_coverage();

        $display("\n================================");

        $display("ALU FUNCTIONAL COVERAGE REPORT");

        $display("================================");

        $display(
            "Opcode Coverage      = %0.2f%%",
            alu_cg.cp_opcode.get_coverage()
        );

        $display(
            "Operand A Coverage   = %0.2f%%",
            alu_cg.cp_operand_a.get_coverage()
        );

        $display(
            "Operand B Coverage   = %0.2f%%",
            alu_cg.cp_operand_b.get_coverage()
        );

        $display(
            "Opcode x Operand A   = %0.2f%%",
            alu_cg.cross_opcode_a.get_coverage()
        );

        $display(
            "Opcode x Operand B   = %0.2f%%",
            alu_cg.cross_opcode_b.get_coverage()
        );

        $display(
            "Overall Coverage     = %0.2f%%",
            alu_cg.get_coverage()
        );

        $display("================================");

    endfunction

endclass

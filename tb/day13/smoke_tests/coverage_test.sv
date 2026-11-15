
module coverage_test;

    bit [3:0] opcode;

    covergroup cg;
        cp_opcode: coverpoint opcode;
    endgroup

    cg cov;

    initial begin

        cov = new();

        opcode = 4'h0;
        cov.sample();

        $display("Coverage = %0.2f%%",
                 cov.get_coverage());

        $finish;

    end

endmodule

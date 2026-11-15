`timescale 1ns/1ps

module smoke_test;

    logic [31:0] a;
    logic [31:0] b;
    logic [3:0]  opcode;

    initial begin
        a      = 32'd10;
        b      = 32'd5;
        opcode = 4'h0;

        #1;

        $display("SystemVerilog smoke test");
        $display("a = %0d, b = %0d, opcode = %h",
                 a, b, opcode);

        $finish;
    end

endmodule
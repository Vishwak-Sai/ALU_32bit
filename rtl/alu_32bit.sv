
`timescale 1ns/1ps

module alu_32bit (

    // Inputs
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [3:0]  opcode,

    // Outputs
    output logic [31:0] result,
    output logic        zero,
    output logic        carry,
    output logic        overflow,
    output logic        valid

);

    // 33-bit temporary variable for arithmetic
    logic [32:0] arith_ext;

    always_comb begin

        // Default assignments
        result    = 32'b0;
        zero      = 1'b0;
        carry     = 1'b0;
        overflow  = 1'b0;
        valid     = 1'b0;
        arith_ext = 33'b0;

        case (opcode)

            // ADD
            4'h0: begin

                valid = 1'b1;

                arith_ext = {1'b0, a} + {1'b0, b};

                result = arith_ext[31:0];

                carry = arith_ext[32];

                overflow = ~(a[31] ^ b[31]) &
                           (result[31] ^ a[31]);

            end

            // SUB
            4'h1: begin

                valid = 1'b1;

                arith_ext = {1'b0, a} - {1'b0, b};

                result = arith_ext[31:0];

                carry = ~arith_ext[32];

                overflow = (a[31] ^ b[31]) &
                           (result[31] ^ a[31]);

            end

            // AND
            4'h2: begin

                valid = 1'b1;

                result = a & b;

            end

            // OR
            4'h3: begin

                valid = 1'b1;

                result = a | b;

            end

            // XOR
            4'h4: begin

                valid = 1'b1;

                result = a ^ b;

            end

            // NOT
            4'h5: begin

                valid = 1'b1;

                result = ~a;

            end

            // SLL
            4'h6: begin

                valid = 1'b1;

                result = a << b[4:0];

            end

            // SRL
            4'h7: begin

                valid = 1'b1;

                result = a >> b[4:0];

            end

            // SLT - Signed comparison
            4'h8: begin

                valid = 1'b1;

                result = ($signed(a) < $signed(b))
                         ? 32'd1 : 32'd0;

            end

            // SLTU - Unsigned comparison
            4'h9: begin

                valid = 1'b1;

                result = (a < b) ? 32'd1 : 32'd0;

            end

            // Invalid opcode
            default: begin

                valid = 1'b0;

            end

        endcase

        // Zero flag
        zero = valid && (result == 32'b0);

    end

endmodule

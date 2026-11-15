
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

    // Combinational ALU logic
    always_comb begin

        // Default assignments
        result   = 32'b0;
        zero     = 1'b0;
        carry    = 1'b0;
        overflow = 1'b0;
        valid    = 1'b0;

        // Opcode decoder
        case (opcode)

            4'h0: begin
                valid = 1'b1;  // ADD
            end

            4'h1: begin
                valid = 1'b1;  // SUB
            end

            4'h2: begin
                valid = 1'b1;  // AND
            end

            4'h3: begin
                valid = 1'b1;  // OR
            end

            4'h4: begin
                valid = 1'b1;  // XOR
            end

            4'h5: begin
                valid = 1'b1;  // NOT
            end

            4'h6: begin
                valid = 1'b1;  // SLL
            end

            4'h7: begin
                valid = 1'b1;  // SRL
            end

            4'h8: begin
                valid = 1'b1;  // SLT
            end

            4'h9: begin
                valid = 1'b1;  // SLTU
            end

            default: begin
                valid = 1'b0;
            end

        endcase

        // Zero flag is meaningful for valid operations.
        // Invalid opcodes must have all flags cleared.
        zero = valid && (result == 32'b0);

    end

endmodule

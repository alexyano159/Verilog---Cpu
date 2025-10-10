module Instruction_Memory_tb;
    parameter DATA_WIDTH = 32;
    parameter MEM_DEPTH = 256;
    reg [DATA_WIDTH-1:0] Address;
    wire [DATA_WIDTH-1:0] Instruction;

    Instruction_Memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .MEM_DEPTH(MEM_DEPTH)
    ) im (
        .Address(Address),
        .Instruction(Instruction)
    );

    reg [DATA_WIDTH-1:0] expected [0:33];
    integer i;

    initial begin
        // ALU & Immediate instructions
        expected[0]  = {5'b00000, 5'd1, 5'd2, 5'd3, 12'b0};
        expected[1]  = {5'b00001, 5'd2, 5'd1, 5'd3, 12'b0};
        expected[2]  = {5'b00010, 5'd3, 5'd0, 5'd1, 12'b0};
        expected[3]  = {5'b00011, 5'd4, 5'd2, 5'd1, 12'b0};
        expected[4]  = {5'b00100, 5'd5, 5'd3, 5'd4, 12'b0};
        expected[5]  = {5'b00101, 5'd1, 5'd5, 5'd3, 12'b0};
        expected[6]  = {5'b00110, 5'd2, 5'd1, 5'd3, 12'b0};
        expected[7]  = {5'b00111, 5'd3, 5'd2, 5'd0, 12'd1};
        expected[8]  = {5'b01000, 5'd4, 5'd3, 5'd0, 12'd1};
        expected[9]  = {5'b01001, 5'd5, 5'd0, 5'd0, 12'b0};
        expected[10] = {5'b01010, 5'd1, 5'd1, 5'd0, 12'd1};
        expected[11] = {5'b01011, 5'd2, 5'd2, 5'd0, 12'd1};
        expected[12] = {5'b01100, 5'd3, 5'd3, 5'd0, 12'd1};
        expected[13] = {5'b01101, 5'd4, 5'd4, 5'd0, 12'd1};
        expected[14] = {5'b01110, 5'd1, 5'd0, 5'd0, 12'b0};
        expected[15] = {5'b01111, 5'd2, 5'd2, 5'd0, 12'b0};
        expected[16] = {5'b00000, 5'd6, 5'd6, 5'd0, 12'd10};
        expected[17] = {5'b00001, 5'd7, 5'd7, 5'd0, -12'd5};
        expected[18] = {5'b00010, 5'd8, 5'd8, 5'd0, 12'h0F0};
        expected[19] = {5'b00011, 5'd9, 5'd9, 5'd0, 12'h00F};
        expected[20] = {5'b00100, 5'd10, 5'd10, 5'd0, 12'hFF0};
        expected[21] = {5'b00101, 5'd11, 5'd11, 5'd0, 12'hF0F};
        expected[22] = {5'b00110, 5'd12, 5'd12, 5'd0, 12'd100};

        // Memory & Control instructions
        expected[23] = {5'b10000, 5'd1, 5'd0, 5'd0, 12'd50};    // LOAD R1 = MEM[R0 + 50]
        expected[24] = {5'b10001, 5'd0, 5'd0, 5'd2, 12'd60};    // STORE MEM[R0 + 60] = R2
        expected[25] = {5'b10000, 5'd3, 5'd1, 5'd0, 12'd4};     // LOAD R3 = MEM[R1 + 4]
        expected[26] = {5'b10001, 5'd0, 5'd2, 5'd4, 12'd8};     // STORE MEM[R2 + 8] = R4
        expected[27] = {5'b10010, 5'd0, 5'd0, 5'd0, 12'd35};    // JUMP to address 35
        expected[28] = {5'b10011, 5'd0, 5'd2, 5'd3, 12'd40};    // BEQ if R2 == R3, branch to 40
        expected[29] = {5'b10100, 5'd0, 5'd4, 5'd5, 12'd45};    // BNE if R4 != R5, branch to 45
        expected[30] = {5'b10101, 5'd0, 5'd6, 5'd7, 12'd50};    // BLT if R6 < R7, branch to 50
        expected[31] = {5'b10110, 5'd0, 5'd8, 5'd9, 12'd55};    // BGT if R8 > R9, branch to 55
        expected[32] = {5'b10111, 5'd0, 5'd10, 5'd11, 12'd60};  // BGE if R10 >= R11, branch to 60
        expected[33] = {5'b11000, 5'd0, 5'd12, 5'd13, 12'd65};  // BLE if R12 <= R13, branch to 65

        // Test all instructions
        for (i = 0; i < 34; i = i + 1) begin
            Address = i * 4; // word aligned
            #1; // allow propagation
            if (Instruction !== expected[i]) begin
                $display("ERROR at Address %0d: got %b, expected %b", Address, Instruction, expected[i]);
            end else begin
                $display("OK at Address %0d: Instruction = %b", Address, Instruction);
            end
        end
        $display("Instruction memory testbench completed.");
        $stop;
    end
endmodule

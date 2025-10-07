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

    reg [DATA_WIDTH-1:0] expected [0:22];
    integer i;

    initial begin
        // Match the encoding exactly to Instruction_Memory.v!
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

        // Test all instructions
        for (i = 0; i < 23; i = i + 1) begin
            Address = i * 4;
            #1;
            if (Instruction !== expected[i]) begin
                $display("ERROR at Address %d: got %b, expected %b", Address, Instruction, expected[i]);
            end else begin
                $display("OK at Address %d: Instruction = %b", Address, Instruction);
            end
        end
    end
endmodule
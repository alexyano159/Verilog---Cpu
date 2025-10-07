module Control_Unit_tb;
    reg clk;
    reg reset;
    reg [31:0] instruction;
    reg zero_flag;
    reg carry_flag;
    reg negative_flag;
    reg overflow_flag;
    wire [4:0] AluControl;
    wire AluSrc;
    wire MemtoReg;
    wire RegDst;
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire Branch;
    wire Jump;
    wire branch_taken;

    Control_Unit uut (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .zero_flag(zero_flag),
        .carry_flag(carry_flag),
        .negative_flag(negative_flag),
        .overflow_flag(overflow_flag),
        .AluControl(AluControl),
        .AluSrc(AluSrc),
        .MemtoReg(MemtoReg),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .branch_taken(branch_taken),
        .Jump(Jump)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset sequence
    initial begin
        reset = 1;
        #12;
        reset = 0;
    end

    // Function to convert state to string
    function [79:0] state_to_string;
        input [3:0] state;
        case (state)
            4'b0000: state_to_string = "FETCH";
            4'b0001: state_to_string = "DECODE";
            4'b0010: state_to_string = "EXECUTE";
            4'b0011: state_to_string = "MEMORY";
            4'b0100: state_to_string = "WRITEBACK";
            default: state_to_string = "UNKNOWN";
        endcase
    endfunction

    // Test instructions(opcode + rs + rt + rd + immediate)
    reg [31:0] test_instructions [0:27];
    initial begin
        test_instructions[0]  = {5'b00000, 5'b00001, 5'b00010, 5'b00011, 12'b0};        // ADD
        test_instructions[1]  = {5'b00001, 5'b00001, 5'b00010, 5'b00011, 12'b0};        // SUB
        test_instructions[2]  = {5'b00010, 5'b00001, 5'b00010, 5'b00011, 12'b0};        // AND
        test_instructions[3]  = {5'b00011, 5'b00001, 5'b00010, 5'b00011, 12'b0};        // OR
        test_instructions[4]  = {5'b00100, 5'b00001, 5'b00010, 5'b00011, 12'b0};        // XOR
        test_instructions[5]  = {5'b00101, 5'b00001, 5'b00010, 5'b00011, 12'b0};        // NOR
        test_instructions[6]  = {5'b00110, 5'b00001, 5'b00010, 5'b00011, 12'b0};        // SLT
        test_instructions[7]  = {5'b00111, 5'b00001, 5'b00010, 5'b00000, 12'b0};        // SLL
        test_instructions[8]  = {5'b01000, 5'b00001, 5'b00010, 5'b00000, 12'b0};        // SRL
        test_instructions[9]  = {5'b01001, 5'b00001, 5'b00010, 5'b00000, 12'b0};        // NOT
        test_instructions[10] = {5'b01010, 5'b00001, 5'b00010, 5'b00000, 12'b0};        // INC
        test_instructions[11] = {5'b01011, 5'b00001, 5'b00010, 5'b00000, 12'b0};        // DEC
        test_instructions[12] = {5'b01100, 5'b00001, 5'b00010, 5'b00000, 12'b0};        // ROL
        test_instructions[13] = {5'b01101, 5'b00001, 5'b00010, 5'b00000, 12'b0};        // ROR
        test_instructions[14] = {5'b01110, 5'b00001, 5'b00010, 5'b00011, 12'b0};        // PASSB
        test_instructions[15] = {5'b01111, 5'b00001, 5'b00010, 5'b00011, 12'b0};        // PASSA
        test_instructions[16] = {5'b10000, 5'b00001, 5'b00010, 5'b00000, 12'b000001};   // LOAD
        test_instructions[17] = {5'b10001, 5'b00001, 5'b00010, 5'b00011, 12'b000010};   // STORE
        test_instructions[18] = {5'b10010, 5'b00000, 5'b00000, 5'b00000, 12'b000011};   // JUMP
        test_instructions[19] = {5'b10011, 5'b00000, 5'b00010, 5'b00011, 12'b000100};   // BEQ
        test_instructions[20] = {5'b10100, 5'b00000, 5'b00010, 5'b00011, 12'b000101};   // BNE
        test_instructions[21] = {5'b10101, 5'b00000, 5'b00010, 5'b00011, 12'b000110};   // BLT
        test_instructions[22] = {5'b10110, 5'b00000, 5'b00010, 5'b00011, 12'b000111};   // BGT
        test_instructions[23] = {5'b10111, 5'b00000, 5'b00010, 5'b00011, 12'b001000};   // BGE
        test_instructions[24] = {5'b11000, 5'b00000, 5'b00010, 5'b00011, 12'b001001};   // BLE
    end

    integer i;
    initial begin
        @(negedge reset);

        // Default flags
        zero_flag = 0;
        carry_flag = 0;
        negative_flag = 0;
        overflow_flag = 0;

        for (i = 0; i < 25; i = i + 1) begin
            instruction = test_instructions[i];

            // Set flags for branch instructions
            case (i)
                19: zero_flag = 1; // BEQ (branch taken)
                20: zero_flag = 0; // BNE (branch not taken)
                21: negative_flag = 1; // BLT
                22: begin negative_flag = 0; zero_flag = 0; end // BGT
                23: negative_flag = 0; // BGE
                24: begin negative_flag = 1; zero_flag = 0; end // BLE
                default: begin zero_flag = 0; negative_flag = 0; end
            endcase

            $display("\n--- Testing Instruction %0d: %b ---", i, instruction);
            @(posedge clk); // FETCH
            $display("State: %s | Time=%0d AluControl=%b AluSrc=%b MemtoReg=%b RegDst=%b RegWrite=%b MemRead=%b MemWrite=%b Branch=%b branch_taken=%b Jump=%b", 
                state_to_string(uut.current_state), $time, AluControl, AluSrc, MemtoReg, RegDst, RegWrite, MemRead, MemWrite, Branch, branch_taken, Jump);
            @(posedge clk); // DECODE
            $display("State: %s | Time=%0d AluControl=%b AluSrc=%b MemtoReg=%b RegDst=%b RegWrite=%b MemRead=%b MemWrite=%b Branch=%b branch_taken=%b Jump=%b", 
                state_to_string(uut.current_state), $time, AluControl, AluSrc, MemtoReg, RegDst, RegWrite, MemRead, MemWrite, Branch, branch_taken, Jump);
            @(posedge clk); // EXECUTE or MEMORY/WRITEBACK
            $display("State: %s | Time=%0d AluControl=%b AluSrc=%b MemtoReg=%b RegDst=%b RegWrite=%b MemRead=%b MemWrite=%b Branch=%b branch_taken=%b Jump=%b", 
                state_to_string(uut.current_state), $time, AluControl, AluSrc, MemtoReg, RegDst, RegWrite, MemRead, MemWrite, Branch, branch_taken, Jump);
            @(posedge clk); // next state
            $display("State: %s | Time=%0d AluControl=%b AluSrc=%b MemtoReg=%b RegDst=%b RegWrite=%b MemRead=%b MemWrite=%b Branch=%b branch_taken=%b Jump=%b", 
                state_to_string(uut.current_state), $time, AluControl, AluSrc, MemtoReg, RegDst, RegWrite, MemRead, MemWrite, Branch, branch_taken, Jump);
        end
        $stop;
    end
endmodule
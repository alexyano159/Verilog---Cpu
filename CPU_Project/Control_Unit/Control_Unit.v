module Control_Unit(
    //inputs
    input clk,
    input reset,
    input [31:0] instruction,
    input zero_flag,
    input carry_flag,
    input negative_flag,
    input overflow_flag,
    //outputs
    output reg [4:0] AluControl,
    output reg AluSrc, // New signal to select ALU source (register or immediate)
    output reg MemtoReg, // New signal to select data to write to register (ALU result or memory data)
    output reg RegDst, // New signal to select destination register
    output reg RegWrite, // New signal to enable register write
    output reg MemRead, // New signal to indicate memory read operation
    output reg MemWrite, // New signal to indicate memory write operation
    output reg Jump,
    output reg Branch, // New signal to indicate a branch instruction
    output reg branch_taken // New signal to indicate if branch condition is met
);
    localparam FETCH= 4'b0000,
               DECODE= 4'b0001,
               EXECUTE= 4'b0010,
               MEMORY= 4'b0011,
               WRITEBACK= 4'b0100;
    reg [3:0] current_state, next_state;
    wire [4:0] opcode;
    assign opcode = instruction[31:27];

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= FETCH;
        else
            current_state <= next_state;
    end

    always @(*) begin 
        // Default values
        AluSrc   = 1'b0;
        MemtoReg = 1'b0;
        RegDst   = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        RegWrite = 1'b0;
        AluControl    = 5'b00000;
        Jump     = 1'b0;
        Branch   = 1'b0;
        branch_taken = 1'b0;

        case (current_state)
            FETCH: begin
                next_state = DECODE;
                AluSrc     = 1'b0;
                MemtoReg   = 1'b0;
                RegDst     = 1'b0;
                RegWrite   = 1'b0;
                MemRead    = 1'b1;
                MemWrite   = 1'b0;
            end

            DECODE: begin
                next_state = EXECUTE;
                AluSrc     = 1'b0;
                MemtoReg   = 1'b0;
                RegDst     = 1'b0;
                RegWrite   = 1'b0;
                MemRead    = 1'b0;
                MemWrite   = 1'b0;
            end

            EXECUTE: begin
                case (opcode)
                    5'b00000: begin // ADD
                        next_state = WRITEBACK;
                        AluControl      = 5'b00000;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b1;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b00001: begin // SUB
                        next_state = WRITEBACK;
                        AluControl      = 5'b00001;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b1;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b00010: begin // AND
                        next_state = WRITEBACK;
                        AluControl      = 5'b00010;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b1;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b00011: begin // OR
                        next_state = WRITEBACK;
                        AluControl      = 5'b00011;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b1;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b00100: begin // XOR
                        next_state = WRITEBACK;
                        AluControl      = 5'b00100;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b1;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b00101: begin // NOR
                        next_state = WRITEBACK;
                        AluControl      = 5'b00101;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b1;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b00110: begin // SLT
                        next_state = WRITEBACK;
                        AluControl      = 5'b00110;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b1;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b00111: begin // SLL
                        next_state = WRITEBACK;
                        AluControl      = 5'b00111;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b1;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b01000: begin // SRL
                        next_state = WRITEBACK;
                        AluControl      = 5'b01000;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b1;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b01001: begin // NOT
                        next_state = WRITEBACK;
                        AluControl      = 5'b01001;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b1;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b01010: begin // INC
                        next_state = WRITEBACK;
                        AluControl      = 5'b01010;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b1;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b01011: begin // DEC
                        next_state = WRITEBACK;
                        AluControl      = 5'b01011;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b1;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b01100: begin // ROL
                        next_state = WRITEBACK;
                        AluControl      = 5'b01100;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b1;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b01101: begin // ROR
                        next_state = WRITEBACK;
                        AluControl      = 5'b01101;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b1;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b01110: begin // Pass B
                        next_state = WRITEBACK;
                        AluControl      = 5'b01110;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b1;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b01111: begin // Pass A
                        next_state = WRITEBACK;
                        AluControl      = 5'b01111;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b1;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b10000: begin // LOAD
                        next_state = MEMORY;
                        AluControl      = 5'b00000; // Use ADD to calculate address
                        AluSrc     = 1'b1;
                        MemtoReg   = 1'b1;
                        RegDst     = 1'b0;
                        RegWrite   = 1'b1;
                        MemRead    = 1'b1;
                        MemWrite   = 1'b0;
                    end
                    5'b10001: begin // STORE
                        next_state = MEMORY;
                        AluControl      = 5'b00000; // Use ADD to calculate address
                        AluSrc     = 1'b1;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b0;
                        RegWrite   = 1'b0;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b1;
                    end
                    5'b10010: begin // JUMP
                        next_state = FETCH;
                        Jump       = 1'b1;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b0;
                        RegWrite   = 1'b0;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b10011: begin // Branch if equal (BEQ)
                        next_state = FETCH;
                        Branch     = 1'b1;
                        branch_taken = (zero_flag) ? 1'b1 : 1'b0;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b0;
                        RegWrite   = 1'b0;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b10100: begin // Branch if not equal (BNE)
                        next_state = FETCH;
                        Branch=1'b1;
                        branch_taken = (!zero_flag) ? 1'b1 : 1'b0;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b0;
                        RegWrite   = 1'b0;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                    5'b10101: begin //Branch if less than (BLT)
                        next_state=FETCH;
                        Branch=1'b1;
                        branch_taken=(negative_flag)?1'b1:1'b0;
                        AluSrc=1'b0;
                        MemtoReg=1'b0;
                        RegDst=1'b0;
                        RegWrite=1'b0;
                        MemRead=1'b0;
                        MemWrite=1'b0;
                    end
                    5'b10110: begin // Branch if greater than (BGT)
                        next_state=FETCH;
                        Branch=1'b1;
                        branch_taken=(~negative_flag & ~zero_flag)?1'b1:1'b0;
                        AluSrc=1'b0;
                        MemtoReg=1'b0;
                        RegDst=1'b0;
                        RegWrite=1'b0;
                        MemRead=1'b0;
                        MemWrite=1'b0;
                    end
                    5'b10111: begin // Branch if greater than or equal (BGE)
                        next_state=FETCH;
                        Branch=1'b1;
                        branch_taken=(~negative_flag)?1'b1:1'b0;
                        AluSrc=1'b0;
                        MemtoReg=1'b0;
                        RegDst=1'b0;
                        RegWrite=1'b0;
                        MemRead=1'b0;
                        MemWrite=1'b0;
                    end
                    5'b11000: begin // Branch if less than or equal (BLE)
                        next_state=FETCH;
                        Branch=1'b1;
                        branch_taken=(negative_flag | zero_flag)?1'b1:1'b0;
                        AluSrc=1'b0;
                        MemtoReg=1'b0;
                        RegDst=1'b0;
                        RegWrite=1'b0;
                        MemRead=1'b0;
                        MemWrite=1'b0;
                    end
                    default: begin // NOP or undefined opcode
                        next_state = FETCH;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b0;
                        RegWrite   = 1'b0;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                endcase
            end

            MEMORY: begin
                case (opcode)
                    5'b10000: begin // LOAD
                        next_state = WRITEBACK;
                        AluSrc     = 1'b1; // Select immediate value for ALU
                        MemtoReg   = 1'b1; // Write data from memory to register
                        RegDst     = 1'b0;
                        RegWrite   = 1'b1; // Enable register write
                        MemRead    = 1'b1; // Enable memory read
                        MemWrite   = 1'b0;
                    end
                    5'b10001: begin // STORE
                        next_state = FETCH;
                        AluSrc     = 1'b1; // Select immediate value for ALU
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b0;
                        RegWrite   = 1'b0;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b1; // Enable memory write
                    end
                    default: begin
                        next_state = FETCH;
                        AluSrc     = 1'b0;
                        MemtoReg   = 1'b0;
                        RegDst     = 1'b0;
                        RegWrite   = 1'b0;
                        MemRead    = 1'b0;
                        MemWrite   = 1'b0;
                    end
                endcase
            end

            WRITEBACK: begin
                next_state = FETCH;
                case (opcode)
                    5'b10000: begin // LOAD
                        AluSrc   = 1'b1;
                        MemtoReg = 1'b1;
                        RegDst   = 1'b0;
                        RegWrite = 1'b1;
                    end
                    // No write back for STORE

                    default:begin
                        AluSrc   = 1'b0;
                        MemtoReg = 1'b0;
                        RegDst   = 1'b0;
                        RegWrite = 1'b0;
                    end
                endcase
                MemRead  = 1'b0;
                MemWrite = 1'b0;
            end
        endcase
    end
endmodule
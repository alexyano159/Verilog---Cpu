module CPU_Top #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 8
) (
    input clk,
    input reset,// Active-high reset
    // Interfaces to Instruction Memory and Data Memory
    input [DATA_WIDTH-1:0] instruction_data,// Instruction from ROM
    input [DATA_WIDTH-1:0] read_data,// Data from RAM
    output [ADDR_WIDTH-1:0] instruction_address,// Address to ROM
    output [ADDR_WIDTH-1:0] data_address,// Address to RAM
    output [DATA_WIDTH-1:0] write_data,// Data to RAM
    output write_enable// RAM Write Enable

    // Debugging Outputs(for waveform viewing)
   `ifdef DEBUG
    , output reg_write_enable
    , output reg_read_enable
    , output [DATA_WIDTH-1:0] alu_result_debug
    , output [DATA_WIDTH-1:0] pc_current
    , output [DATA_WIDTH-1:0] reg_data1
    , output [DATA_WIDTH-1:0] reg_data2
    , output [DATA_WIDTH-1:0] pc
    , output [DATA_WIDTH-1:0] mdr_debug
    , output [DATA_WIDTH-1:0] ir_debug
    , output [ADDR_WIDTH-1:0] mar_debug
    , output [DATA_WIDTH-1:0] b
    , output [DATA_WIDTH-1:0] a
    , output [4:0] AluControl
    , output AluSrc
    , output MemtoReg
    , output RegDst
    , output RegWrite
    , output MemRead
    , output MemWrite
    , output Jump
    , output Branch
`endif
);
// Internal signals and wiring
wire [DATA_WIDTH-1:0] alu_A, alu_B, write_back, address_bus, pc_next, pc_current;
wire [DATA_WIDTH-1:0] jump_target, branch_target;
wire [DATA_WIDTH-1:0] reg_data1, reg_data2, mdr, ir, immediate;
wire [ADDR_WIDTH-1:0] mar;
wire [4:0] rs1_addr, rs2_addr, rd_addr;
wire ir_load, pc_inc, pc_load, mar_load, mdr_load;
wire [DATA_WIDTH-1:0] alu_result;
wire alu_carry, alu_zero, alu_overflow, alu_negative;
wire [4:0] AluControl;
wire AluSrc, MemtoReg, RegDst, RegWrite, MemRead, MemWrite, Jump, Branch, branch_taken;
wire [3:0] current_state;

// ALU
Cpu_Alu alu (
    .A(alu_A),            // [DATA_WIDTH-1:0] Operand A (from register or immediate mux)
    .B(alu_B),            // [DATA_WIDTH-1:0] Operand B (from register or immediate mux)
    .ALU_Sel(AluControl), // [4:0]  Operation select (from Control Unit)
    .ALU_Out(alu_result), // [DATA_WIDTH-1:0] ALU result
    .CarryOut(alu_carry), // Status flags
    .Zero(alu_zero),
    .Overflow(alu_overflow),
    .Negative(alu_negative)
);

// Register File
Register_File reg_file (
    .clk(clk),
    .reset(reset),              // Active-high reset
    .write_en(RegWrite),      // Write enable (from Control Unit)
    .read_reg1(rs1_addr),     // [4:0] Read register 1 address (from IR)
    .read_reg2(rs2_addr),     // [4:0] Read register 2 address (from IR)
    .write_reg(rd_addr),      // [4:0] Write register address (from IR/RegDst)
    .write_data(write_back),  // [DATA_WIDTH-1:0] Data to write (from ALU or memory)
    .read_data1(reg_data1),   // [DATA_WIDTH-1:0] Output 1 
    .read_data2(reg_data2)    // [DATA_WIDTH-1:0] Output 2
);

// Instruction Register
Instruction_Register ir_reg (
    .clk(clk),
    .reset(reset),// Active-high reset
    .load(ir_load),           // Load enable for instruction register
    .data_in(instruction_data), // Instruction from memory
    .instruction(ir)           // Output: latched instruction
);

// Program Counter
Program_Counter pc_reg (
    .clk(clk),
    .reset(reset),// Active-high reset
    .increment(pc_inc),        // PC increment enable
    .load(pc_load),            // PC load enable (for jumps/branches)
    .pc_in(pc_next),           // [DATA_WIDTH-1:0] Next PC value
    .pc_out(pc_current)        // [DATA_WIDTH-1:0] Current PC value
);

// Memory Address Register
Memory_Address_Register mar_reg (
    .clk(clk),
    .reset(reset),// Active-high reset
    .load(mar_load),          // MAR load enable
    .address_in(address_bus), // [DATA_WIDTH-1:0] Address to latch
    .address_out(mar)         // [ADDR_WIDTH-1:0] Latched address
);

// Memory Data Register
Memory_Data_Register mdr_reg (
    .clk(clk),
    .reset(reset),// Active-high reset
    .data_in(read_data),      // Data from memory
    .write_enable(mdr_load),  // MDR load enable
    .data_out(mdr)            // Latched memory data
);

// Data Memory is external
// Instruction Memory is external

// Control Unit
Control_Unit cu (
    .clk(clk),
    .reset(reset),// Active-high reset
    .instruction(ir),
    .zero_flag(alu_zero),
    .carry_flag(alu_carry),
    .negative_flag(alu_negative),
    .overflow_flag(alu_overflow),
    .AluControl(AluControl),
    .AluSrc(AluSrc),
    .MemtoReg(MemtoReg),
    .RegDst(RegDst),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .Jump(Jump),
    .Branch(Branch),
    .branch_taken(branch_taken),
    .current_state(current_state)
);
// Assign outputs to memory interfaces
assign rd_addr = ir[26:22];   // according to instruction format
assign rs1_addr = ir[21:17]; // according to instruction format
assign rs2_addr = ir[16:12]; // according to instruction format
assign immediate = {{20{ir[11]}}, ir[11:0]}; // Sign-extended immediate
assign jump_target = {pc_current[DATA_WIDTH-1:DATA_WIDTH-4], ir[25:0], 2'b00}; // Jump target address
assign branch_target = pc_current + 4 + (immediate << 2); // Branch target address
assign alu_A = reg_data1;// Always from register
assign alu_B = AluSrc ? immediate : reg_data2;// From register or immediate
assign write_back = MemtoReg ? mdr : alu_result;// From memory or ALU
assign address_bus = MemRead || MemWrite ? (reg_data1 + immediate) : pc_current;// Address for memory or PC
// Next PC logic
assign pc_next = Jump ? jump_target :
                 (Branch && branch_taken) ? branch_target :
                 pc_current + 4;
assign instruction_address=pc_current[9:2];// Address to Instruction Memory
assign data_address=mar[7:0];// Address to RAM from MAR
assign write_data=reg_data2;// Data to write to RAM from register
assign write_enable=MemWrite;// RAM Write Enable
// Control signals for registers
assign ir_load = current_state == 4'b0000; // Load IR in FETCH state
assign pc_inc = current_state == 4'b0001; // PC increment in DECODE state
assign pc_load = Jump || (Branch && branch_taken); // Load PC on jump or taken branch
assign mar_load = MemRead || MemWrite; // Load MAR when accessing memory
assign mdr_load = MemRead; // Load MDR on memory read
// Debugging outputs
`ifdef DEBUG
assign pc = pc_current;
assign a = alu_A;
assign b = alu_B;
assign reg_write_enable = RegWrite;
assign reg_read_enable = 1'b1; // Always reading registers
assign alu_result_debug = alu_result;
assign mdr_debug = mdr;
assign ir_debug = ir;
assign mar_debug = mar;
`endif

endmodule

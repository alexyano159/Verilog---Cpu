module CPU_Top_tb;
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 8;
    parameter REG_ADDR_WIDTH = 5;
    parameter MEM_DEPTH = 256;
    reg clk;
    reg reset;
    wire [DATA_WIDTH-1:0] instruction_data;
    wire [DATA_WIDTH-1:0] read_data;
    wire [ADDR_WIDTH-1:0] instruction_address;
    wire [ADDR_WIDTH-1:0] data_address;
    wire [DATA_WIDTH-1:0] write_data;
    wire write_enable;
    // Debugging Outputs(for waveform viewing)
    `ifdef DEBUG
    wire reg_write_enable;
    wire reg_read_enable;
    wire [DATA_WIDTH-1:0] alu_result_debug;
    wire [DATA_WIDTH-1:0] pc_current_debug;
    wire [DATA_WIDTH-1:0] reg_data1_debug;
    wire [DATA_WIDTH-1:0] reg_data2_debug;
    wire [DATA_WIDTH-1:0] pc_debug;
    wire [DATA_WIDTH-1:0] mdr_debug;
    wire [DATA_WIDTH-1:0] ir_debug;
    wire [ADDR_WIDTH-1:0] mar_debug;
    wire [DATA_WIDTH-1:0] a_debug;
    wire [DATA_WIDTH-1:0] b_debug;
    wire [4:0] AluControl_debug;
    wire AluSrc_debug;
    wire MemtoReg_debug;
    wire RegDst_debug;
    wire RegWrite_debug;
    wire MemRead_debug;
    wire MemWrite_debug;
    wire Jump_debug;
    wire Branch_debug;
    `endif 
    // Instantiate the CPU_Top module
    CPU_Top #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    )
    `ifdef DEBUG
    cpu (
        .clk(clk),
        .reset(reset),
        .instruction_data(instruction_data),
        .read_data(read_data),
        .instruction_address(instruction_address),
        .data_address(data_address),
        .write_data(write_data),
        .write_enable(write_enable),
        // Debugging Outputs
        .reg_write_enable(reg_write_enable),
        .reg_read_enable(reg_read_enable),
        .alu_result_debug(alu_result_debug),
        .pc_current_debug(pc_current_debug),
        .reg_data1_debug(reg_data1_debug),
        .reg_data2_debug(reg_data2_debug),
        .pc_debug(pc_debug),
        .mdr_debug(mdr_debug),
        .ir_debug(ir_debug),
        .mar_debug(mar_debug),
        .b_debug(b_debug),
        .a_debug(a_debug),
        .AluControl_debug(AluControl_debug),
        .AluSrc_debug(AluSrc_debug),
        .MemtoReg_debug(MemtoReg_debug),
        .RegDst_debug(RegDst_debug),
        .RegWrite_debug(RegWrite_debug),
        .MemRead_debug(MemRead_debug),
        .MemWrite_debug(MemWrite_debug),
        .Jump_debug(Jump_debug),
        .Branch_debug(Branch_debug)
    );
    `else
    cpu (
        .clk(clk),
        .reset(reset),
        .instruction_data(instruction_data),
        .read_data(read_data),
        .instruction_address(instruction_address),
        .data_address(data_address),
        .write_data(write_data),
        .write_enable(write_enable)
    );
    `endif

    //instantiate the Instruction Memory
    Instruction_Memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .MEM_DEPTH(MEM_DEPTH)
    ) inst_mem (
        .Address(instruction_address),
        .Instruction(instruction_data)
    );

    //instantiate the Data Memory
    Data_Memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) data_mem (
       .clk(clk),
       .Address(data_address),
       .Write_Data(write_data),
       .Mem_Write(write_enable),
       .Mem_Read(1'b1), // Always read for simplicity
       .Read_Data(read_data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #8.75 clk = ~clk; // 17.5 time units clock period
    end
    // Reset sequence
    initial begin 
        reset=1;
        #20;
        reset=0;
    end 
    // Simulation duration
    always @(posedge clk) begin
        `ifdef DEBUG
            $display(
            "Time: %0t | PC: %h | IR: %h | ALU: %h | MDR: %h | Reg1: %h | Reg2: %h | RegWrite: %b | MemWrite: %b | AluCtrl: %h | Jump: %b | Branch: %b",
            $time, pc_current_debug, ir_debug, alu_result_debug, mdr_debug,
            reg_data1_debug, reg_data2_debug, reg_write_enable, MemWrite_debug, AluControl_debug, Jump_debug, Branch_debug
            );
        `else
            $display("Time: %0t | instruction_address: %h | data_address: %h | write_data: %h | write_enable: %b",
            $time, instruction_address, data_address, write_data, write_enable);
        `endif
        if ($time > 700)
            $finish;
    end
    always @(posedge clk) begin
        `ifdef DEBUG
        $display("Time=%0t | PC=%h | IR=%h | Reg1=%h | Reg2=%h | ALU=%h | MAR=%h | MDR=%h | DataAddr=%h | WriteData=%h | WriteEn=%b",
            $time, pc_current_debug, ir_debug, reg_data1_debug, reg_data2_debug, alu_result_debug, mar_debug, mdr_debug, data_address, write_data, write_enable);
        `endif
    end
endmodule
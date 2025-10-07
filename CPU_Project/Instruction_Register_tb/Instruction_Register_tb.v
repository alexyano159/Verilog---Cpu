module Instruction_Register_tb;
    parameter DATA_WIDTH = 32;
    reg clk;
    reg reset;
    reg load;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] instruction;

    // Instantiate the Instruction Register
    Instruction_Register #(
    
        .DATA_WIDTH(DATA_WIDTH)
    ) ir (
        .clk(clk),
        .reset(reset),
        .load(load),
        .data_in(data_in),
        .instruction(instruction)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    initial begin
        // Test sequence
        reset = 1; load = 0; data_in = 32'hA5A5A5A5;
        #10;
        
        reset = 0; 
        #10;
        
        load = 1; 
        #10;
        
        load = 0; 
        #20;

        // Load another instruction
        load = 1; data_in = 32'h5A5A5A5A;
        #10;
        
        load = 0; 
        #20;

        // Reset the instruction register
        reset = 1; 
        #10;

        reset = 0; 
        #20;

        $stop;
    end

    initial begin
        $monitor("Time:%0t | reset=%b | load=%b | data_in=%h instruction=%h", 
                 $time, reset, load, data_in, instruction);
    end
endmodule
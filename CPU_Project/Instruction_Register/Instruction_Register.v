module Instruction_Register #(
    parameter DATA_WIDTH = 32
)(  
    input clk,
    input reset,
    input load,
    input [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] instruction
);
    always @(posedge clk or posedge reset) begin
        if (reset) 
            instruction <= {DATA_WIDTH{1'b0}}; // Clear instruction on reset
        else if (load) 
            instruction <= data_in; // Load new instruction
    end
endmodule
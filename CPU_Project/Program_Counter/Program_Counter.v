module Program_Counter #(
    parameter DATA_WIDTH = 32
)(
    input clk,
    input reset,
    input increment,
    input load,
    input [DATA_WIDTH-1:0] pc_in,
    output reg [DATA_WIDTH-1:0] pc_out//[9:2] for addressing Instruction Memory 
);
    always @(posedge clk or posedge reset) begin
        if (reset) 
            pc_out <= {DATA_WIDTH{1'b0}}; // Reset PC to 0
        else if (load) 
            pc_out <= pc_in; // Load new PC value
        else if (increment) 
            pc_out <= pc_out + 4; // Increment PC by 4
    end
endmodule
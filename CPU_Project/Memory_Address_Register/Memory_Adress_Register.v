module Memory_Address_Register #(
    parameter DATA_WIDTH = 32
)(
    input clk,
    input reset,
    input load,
    //32 bit address bus,
    input [DATA_WIDTH-1:0] address_in,
    output reg [DATA_WIDTH-1:0] address_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) 
            address_out <= {DATA_WIDTH{1'b0}}; // Clear address on reset
        else if (load) 
            address_out <= address_in; // Load new address
    end
endmodule
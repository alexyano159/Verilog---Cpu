module Memory_Address_Register #(
    parameter ADDR_WIDTH = 8
)(
    input clk,
    input reset,
    input load,
    input [ADDR_WIDTH-1:0] address_in,
    output reg [ADDR_WIDTH-1:0] address_out
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            address_out <= {ADDR_WIDTH{1'b0}};
        else if (load)
            address_out <= address_in;
    end
endmodule

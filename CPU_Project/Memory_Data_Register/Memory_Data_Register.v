module Memory_Data_Register #(
    parameter DATA_WIDTH = 32
)(
    input wire clk,
    input wire reset,
    input wire [DATA_WIDTH-1:0] data_in,
    input wire write_enable,
    output reg [DATA_WIDTH-1:0] data_out
);
    always @(posedge clk or posedge reset) begin 
        if (reset) 
            data_out <= {DATA_WIDTH{1'b0}};
        else if (write_enable) 
            data_out <= data_in;

    end 
endmodule
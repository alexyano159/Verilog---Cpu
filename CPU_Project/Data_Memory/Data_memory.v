module Data_Memory #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 8 // 256 locations
)(
    input clk,
    input [ADDR_WIDTH-1:0] Address,
    input [DATA_WIDTH-1:0] Write_Data,
    input Mem_Write,
    input Mem_Read,
    output reg [DATA_WIDTH-1:0] Read_Data
);
    reg [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1]; // 256 x 32 bits memory
    // Initialize memory to zero
    integer i;
    initial begin  
        for(i=0;i<(1<<ADDR_WIDTH);i=i+1)// Initialize memory to zero
            memory[i] = {DATA_WIDTH{1'b0}};
    end

    // Synchronous Write
    always @(posedge clk) begin
        if(Mem_Write)
            memory[Address] <= Write_Data;
    end

    // Asynchronous Read
    always @(*) begin
        if (Mem_Read)
            Read_Data = memory[Address];
        else
            Read_Data = {DATA_WIDTH{1'b0}}; // Output zero if not reading
    end
endmodule
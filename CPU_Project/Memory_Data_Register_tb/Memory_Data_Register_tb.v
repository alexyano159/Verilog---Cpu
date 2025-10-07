module Memory_Data_Register_tb;
parameter DATA_WIDTH = 32;
reg clk;
reg reset;
reg [DATA_WIDTH-1:0] data_in;
reg write_enable;
wire [DATA_WIDTH-1:0] data_out;

Memory_Data_Register #(
    .DATA_WIDTH(DATA_WIDTH)
    ) mdr (
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .write_enable(write_enable),
    .data_out(data_out));

initial begin  
    clk = 0;
    forever #5 clk = ~clk; // Clock generation

end
initial begin
    // Test sequence
    $monitor("Time:%0t | clock=%b | reset=%b | write_enable=%b | data_in=%h | data_out=%h", 
             $time,clk, reset, write_enable, data_in, data_out);
    reset = 1; write_enable = 0; data_in = 32'hDEADBEEF;
    #10;

    reset = 0; 
    #10;
    
    write_enable = 1; 
    #10;
    
    write_enable = 0; 
    #20;

    // Load another value
    write_enable = 1; data_in = 32'hCAFEBABE;
    #10;
    
    write_enable = 0; 
    #20;

    // Reset the register
    reset = 1; 
    #10;

    reset = 0; 
    #20;

    $stop;
    end
endmodule
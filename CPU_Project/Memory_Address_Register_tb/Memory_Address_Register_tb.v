module Memory_Address_Register_tb;
parameter DATA_WIDTH = 32;
reg clk;
reg reset;
reg [DATA_WIDTH-1:0] address_in;
reg load;
wire [DATA_WIDTH-1:0] address_out;
Memory_Address_Register # (
    .DATA_WIDTH(DATA_WIDTH)
   ) mar (
    .clk(clk),
    .reset(reset),
    .load(load),
    .address_in(address_in),
    .address_out(address_out));
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Clock generation
end
initial begin
    // Test sequence
    $monitor("Time:%0t | clock=%b | reset=%b | load=%b | address_in=%h | address_out=%h", 
             $time, clk, reset, load, address_in, address_out);
    reset = 1; load = 0; address_in = 32'h0000ABCD;
    #10;
    
    reset = 0; 
    #10;
    
    load = 1; 
    #10;
    
    load = 0; 
    #20;

    // Load another value
    load = 1; address_in = 32'h12345678;
    #10;
    
    load = 0; 
    #20;

    // Reset the register
    reset = 1; 
    #10;

    reset = 0; 
    #20;

    $stop;
    end
endmodule
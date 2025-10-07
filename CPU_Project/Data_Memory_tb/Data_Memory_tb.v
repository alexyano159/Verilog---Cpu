module Data_Memory_tb ;
parameter DATA_WIDTH=32;
parameter ADDR_WIDTH=8;
reg clk;
reg [ADDR_WIDTH-1:0] Address;
reg [DATA_WIDTH-1:0] Write_Data;
reg Mem_Write;
reg Mem_Read;
wire [DATA_WIDTH-1:0] Read_Data;
Data_Memory #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) dm (
    .clk(clk),
    .Address(Address),
    .Write_Data(Write_Data),
    .Mem_Write(Mem_Write),
    .Mem_Read(Mem_Read),
    .Read_Data(Read_Data)
);

initial begin
    clk=0;
    forever #5 clk=~clk;
end

initial begin
    //reset all signals
    clk = 0;
    Address = 8'h00;
    Write_Data = 32'b0;
    Mem_Write = 0;
    Mem_Read = 0;

    //write 32'hA5A5A5A5 to address 8'h10
    Address=8'h10;
    Write_Data=32'hA5A5A5A5;
    Mem_Write=1;
    Mem_Read=0;
    @(posedge clk);
    Mem_Write=0;
    Mem_Read=1;
    @(posedge clk);
    $display("At posedge clk, Address=%h, Write_Data=%h, Mem_Write=%b, Mem_Read=%b, Read_Data=%h",
         Address, Write_Data, Mem_Write, Mem_Read, Read_Data);

    //read from address 8'h10
    @(posedge clk);

    //read from address 8'h11 (should be 0)
    Address=8'h11;
    @(posedge clk);
    $display("At posedge clk, Address=%h, Write_Data=%h, Mem_Write=%b, Mem_Read=%b, Read_Data=%h",
         Address, Write_Data, Mem_Write, Mem_Read, Read_Data);

    @(posedge clk);

    //write 32'h5A5A5A5A to address 8'h11
    Address=8'h11;
    Write_Data=32'h5A5A5A5A;
    Mem_Write=1;
    Mem_Read=0;
    @(posedge clk);
    Mem_Write=0;
    Mem_Read=1;
    @(posedge clk);
    $display("At posedge clk, Address=%h, Write_Data=%h, Mem_Write=%b, Mem_Read=%b, Read_Data=%h",
         Address, Write_Data, Mem_Write, Mem_Read, Read_Data);

    //read from address 8'h11
    @(posedge clk);
    Mem_Read=0;
    @(posedge clk);

    //write 0 to adress 8'h10
    Address=8'h10;
    Write_Data=32'b0;
    Mem_Write=1;
    Mem_Read=0;
    @(posedge clk);
    Mem_Write=0;
    Mem_Read=1;
    @(posedge clk);
    $display("At posedge clk, Address=%h, Write_Data=%h, Mem_Write=%b, Mem_Read=%b, Read_Data=%h",
         Address, Write_Data, Mem_Write, Mem_Read, Read_Data);

    $stop;
end
endmodule

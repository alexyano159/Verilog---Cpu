module Register_File_tb;
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 5; // 5 bits to address 32 registers
    reg clk;
    reg reset; 
    reg write_en;
    reg [ADDR_WIDTH-1:0] read_reg1;
    reg [ADDR_WIDTH-1:0] read_reg2;
    reg [ADDR_WIDTH-1:0] write_reg;
    reg [DATA_WIDTH-1:0] write_data;
    wire [DATA_WIDTH-1:0] read_data1;
    wire [DATA_WIDTH-1:0] read_data2;

    // Instantiate the Register File
    Register_File #(
        .DATA_WIDTH(DATA_WIDTH)
    ) rf (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    // Monitor registers
    initial begin
        $monitor("Time=%0t | read_reg1=%b read_data1=0x%h | read_reg2=%b read_data2=0x%h | write_reg=%b write_data=0x%h write_en=%b", 
                  $time, read_reg1, read_data1, read_reg2, read_data2, write_reg, write_data, write_en);
    end

    initial begin
        // Initialize signals
        reset = 1; // Assert reset
        write_en = 0;
        read_reg1 = 5'b00000;
        read_reg2 = 5'b00000;
        write_reg = 5'b00000;
        write_data = 32'b0;

        // Release reset after some time
        #10;
        reset = 0; // Deassert reset

        // Test writing to registers
        #10;
        write_en = 1;
        write_reg = 5'b00001; // Write to register 1
        write_data = 32'hAAAAAAAA;

        #10;
        write_reg = 5'b00010; // Write to register 2
        write_data = 32'hCCCCCCCC;

        #10;
        write_en = 0; // Disable writing

        // Test reading from registers
        #10;
        read_reg1 = 5'b00001; // Read from register 1
        read_reg2 = 5'b00010; // Read from register 2

        #10;
        read_reg1 = 5'b00000; // Read from register 0 (expected - 0)
        read_reg2 = 5'b00011; // Read from register 3 (expected - 0)

        // Test writing to register 0 (expected -  change)
        #10;
        write_en = 1;
        write_reg = 5'b00000; // Attempt to write to register 0
        write_data = 32'hFFFFFFFF;
    end
endmodule

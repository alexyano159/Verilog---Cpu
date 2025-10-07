module Program_Counter_tb;
    parameter DATA_WIDTH = 32;
    reg clk;
    reg reset;
    reg increment;
    reg load;
    reg [DATA_WIDTH-1:0] pc_in;
    wire [DATA_WIDTH-1:0] pc_out;

    Program_Counter # (
        .DATA_WIDTH(DATA_WIDTH)
    ) pc (
        .clk(clk),
        .reset(reset),
        .increment(increment),
        .load(load),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        increment = 0;
        load = 0;
        pc_in = 32'b0;

        // Test reset
        #5 reset = 1;
        #10;
        reset = 0; // Assert reset
        #10;
        
        // Test increment
        increment = 1; #20; // Increment PC
        increment = 0; #10;

        // Test load
        pc_in = 32'h00000010; // Load value
        @(posedge clk); // Wait for clock edge
        load = 1; 
        @(posedge clk);
         load = 0; #10;

        // Test increment again
        increment = 1; #20; // Increment PC
        increment = 0; #10;

        // Finish simulation
        #20 $stop;
    end

    // Clock generation
    always #5 clk = ~clk;

    // show outputs
    initial begin
        $monitor("Time: %0t | Reset: %b | Increment: %b | Load: %b | PC In: %h | PC Out: %h", 
                 $time, reset, increment, load, pc_in, pc_out);
    end
endmodule
`timescale 1ns / 1ps

module mux4to1_tb;

  // Inputs
  reg [1:0] sel;
  reg [3:0] in;

  // Outputs
  wire out;

  // Instantiate the Unit Under Test (UUT)
  mux4to1 uut (
    .sel(sel),
    .in(in),
    .out(out)
  );

  initial begin
    // Initialize Inputs
    in = 4'b1011;
    sel = 2'b00;

    // Test case 0: sel = 00, out should be in[0] (1)
    #10 sel = 2'b00; #10;
    $display("Time: %0t, in: %b, sel: %b, out: %b", $time, in, sel, out);
    //if (out == in[0]) $display("Test Case 0 Passed"); else $display("Test Case 0 Failed");

    // Test case 1: sel = 01, out should be in[1] (1)
    #10 sel = 2'b01;#10;
    //$display("Time: %0t, in: %b, sel: %b, out: %b", $time, in, sel, out);
    if (out == in[1]) $display("Test Case 1 Passed"); else $display("Test Case 1 Failed");

    // Test case 2: sel = 10, out should be in[2] (0)
    #10 sel = 2'b10;#10;
    //$display("Time: %0t, in: %b, sel: %b, out: %b", $time, in, sel, out);
    if (out == in[2]) $display("Test Case 2 Passed!"); else $display("Test Case 2 Failed");

    // Test case 3: sel = 11, out should be in[3] (1)
    #10 sel = 2'b11;#10;
    //$display("Time: %0t, in: %b, sel: %b, out: %b", $time, in, sel, out);
    if (out == in[3]) $display("Test Case 3 Passed!"); else $display("Test Case 3 Failed");

    // Additional test cases
    #10 in = 4'b0110; sel = 2'b10;#10;
    //$display("Time: %0t, in: %b, sel: %b, out: %b", $time, in, sel, out);
    if (out == in[2]) $display("Test Case 4 Passed!"); else $display("Test Case 4 Failed");


    $finish;
  end

endmodule

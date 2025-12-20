`timescale 1ns / 1ps

module mux8to1_tb;

  // Inputs
  reg [2:0] sel;
  reg [7:0] in;

  // Outputs
  wire out;

  // Instantiate the Unit Under Test (UUT)
  mux8to1 uut (
    .sel(sel),
    .in(in),
    .out(out)
  );

  initial begin
    // Initialize Inputs
    in = 8'b10101101;
    sel = 3'b000;

    // Test case 0: sel = 000, out should be in[0] (1)
    #10 sel = 3'b000;#10;
    //$display("Time: %0t, in: %b, sel: %b, out: %b", $time, in, sel, out);
    if (out == in[0]) $display("Test Case 0 Passed!"); else $display("Test Case 0 Failed");

    // Test case 1: sel = 001, out should be in[1] (0)
    #10 sel = 3'b001;#10;
    //$display("Time: %0t, in: %b, sel: %b, out: %b", $time, in, sel, out);
    if (out == in[1]) $display("Test Case 1 Passed!"); else $display("Test Case 1 Failed");

    // Test case 2: sel = 010, out should be in[2] (1)
    #10 sel = 3'b010;#10;
    //$display("Time: %0t, in: %b, sel: %b, out: %b", $time, in, sel, out);
    if (out == in[2]) $display("Test Case 2 Passed!"); else $display("Test Case 2 Failed");

    // Test case 3: sel = 011, out should be in[3] (0)
    #10 sel = 3'b011;#10;
    //$display("Time: %0t, in: %b, sel: %b, out: %b", $time, in, sel, out);
    if (out == in[3]) $display("Test Case 3 Passed!"); else $display("Test Case 3 Failed");

     // Test case 4: sel = 100, out should be in[4] (1)
    #10 sel = 3'b100;#10;
    //$display("Time: %0t, in: %b, sel: %b, out: %b", $time, in, sel, out);
    if (out == in[4]) $display("Test Case 4 Passed!"); else $display("Test Case 4 Failed");

     // Test case 5: sel = 101, out should be in[5] (0)
    #10 sel = 3'b101;#10;
    //$display("Time: %0t, in: %b, sel: %b, out: %b", $time, in, sel, out);
    if (out == in[5]) $display("Test Case 5 Passed!"); else $display("Test Case 5 Failed");

    // Test case 6: sel = 110, out should be in[6] (1)
    #10 sel = 3'b110;#10;
    //$display("Time: %0t, in: %b, sel: %b, out: %b", $time, in, sel, out);
    if (out == in[6]) $display("Test Case 6 Passed!"); else $display("Test Case 6 Failed");

    // Test case 7: sel = 111, out should be in[7] (0)
    #10 sel = 3'b111;#10;
    //$display("Time: %0t, in: %b, sel: %b, out: %b", $time, in, sel, out);
    if (out == in[7]) $display("Test Case 7 Passed!"); else $display("Test Case 7 Failed");

    // Additional test cases
    #10 in = 8'b00110011; sel = 3'b010;#10;
    //$display("Time: %0t, in: %b, sel: %b, out: %b", $time, in, sel, out);
    if (out == in[2]) $display("Test Case 8 Passed!"); else $display("Test Case 8 Failed");


    $finish;
  end

endmodule

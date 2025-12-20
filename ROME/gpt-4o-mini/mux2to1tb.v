`timescale 1ns / 1ps

module mux2to1_tb;

  // Inputs
  reg in1;
  reg in2;
  reg select;

  // Outputs
  wire out;

  // Instantiate the Unit Under Test (UUT)
  mux2to1 uut (
    .in1(in1),
    .in2(in2),
    .select(select),
    .out(out)
  );

  initial begin
    // Initialize Inputs
    in1 = 0;
    in2 = 1;
    select = 0;

    // Test case 1: select = 0, out should be in1 (0)
    #10 select = 0; #10;
    //$display("Time: %0t, in1: %b, in2: %b, select: %b, out: %b", $time, in1, in2, select, out);
    if (out == in1) $display("Passed!"); else $display("Test Case 1 Failed");

    // Test case 2: select = 1, out should be in2 (1)
    #10 select = 1;#10;
    //$display("Time: %0t, in1: %b, in2: %b, select: %b, out: %b", $time, in1, in2, select, out);
    if (out == in2) $display("Passed!"); else $display("Test Case 2 Failed");

    // Additional test cases
    #10 in1 = 1; in2 = 0; select = 0;#10;
    //$display("Time: %0t, in1: %b, in2: %b, select: %b, out: %b", $time, in1, in2, select, out);
    if (out == in1) $display("Passed!"); else $display("Test Case 3 Failed");

    #10 in1 = 1; in2 = 0; select = 1;#10;
    //$display("Time: %0t, in1: %b, in2: %b, select: %b, out: %b", $time, in1, in2, select, out);
    if (out == in2) $display("Passed!"); else $display("Test Case 4 Failed");

    $finish;
  end

endmodule

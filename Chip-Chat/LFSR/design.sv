Design an 8-bit LFSR in Verilog:
It generates a sequence of bits by shifting the bits left in a shift register and using a linear function, typically XOR gates, to combine specific bits (taps) to produce the next bit.

module top_module (
    input clk,
    input reset_n,
    output [7:0] data
);

reset value when reset_n is low (initial state): 8'b10001010
 taps at data[0], data[3], data[5], data[6]

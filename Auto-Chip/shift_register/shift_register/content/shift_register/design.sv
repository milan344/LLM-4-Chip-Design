create a Verilog model for a shift register. It must meet the following specifications:
- Inputs:
- Clock
- Active-low reset
- Data (1 bit)
- Shift enable
- Outputs:
- Data (8 bits)

here is an starting module for you:

module top_module(
  input clk,
  input reset_n,
  input data_n,
  input shift_enable,
  output [7:0] data_out
);


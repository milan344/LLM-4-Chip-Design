module top_module(
  input clk,
  input reset_n,
  input data_n,
  input shift_enable,
  output reg [7:0] data_out
);

always @(posedge clk or negedge reset_n) begin
  if (!reset_n) begin
    data_out <= 8'b0;
  end else if (shift_enable) begin
    data_out <= {data_n, data_out[7:1]};
  end
end

endmodule

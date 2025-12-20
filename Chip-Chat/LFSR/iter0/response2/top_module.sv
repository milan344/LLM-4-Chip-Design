module top_module (
    input clk,
    input reset_n,
    output reg [7:0] data
);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        data <= 8'b10001010; // Reset value
    end else begin
        // Calculate the next bit using taps at data[0], data[3], data[5], and data[6]
        data <= {data[6:0], data[0] ^ data[3] ^ data[5] ^ data[6]};
    end
end

endmodule

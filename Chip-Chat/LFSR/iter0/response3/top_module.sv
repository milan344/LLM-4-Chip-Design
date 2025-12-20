module top_module (
    input clk,
    input reset_n,
    output reg [7:0] data
);

    // Taps for the LFSR
    wire new_bit = data[0] ^ data[3] ^ data[5] ^ data[6];

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            data <= 8'b10001010; // Initial state
        end else begin
            data <= {data[6:0], new_bit}; // Shift left and insert new bit
        end
    end

endmodule

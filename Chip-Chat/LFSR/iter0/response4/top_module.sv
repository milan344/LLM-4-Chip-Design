module top_module (
    input clk,
    input reset_n,
    output reg [7:0] data
);

    // Initialize the LFSR with the reset value
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            data <= 8'b10001010;  // Initial state
        end else begin
            // Calculate the new bit using XOR of the taps
            wire new_bit = data[0] ^ data[3] ^ data[5] ^ data[6];
            // Shift the register left and insert the new_bit at the least significant position
            data <= {data[6:0], new_bit};
        end
    end
endmodule

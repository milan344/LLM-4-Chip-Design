module top_module (
    input clk,
    input reset_n,
    output reg [7:0] data
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            data <= 8'b10001010; // reset value
        end else begin
            // Calculate the next bit
            wire next_bit = data[0] ^ data[3] ^ data[5] ^ data[6];
            // Shift left and insert the next bit at data[0]
            data <= {data[6:0], next_bit};
        end
    end
endmodule

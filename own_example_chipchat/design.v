module sram_system (
    input wire [1:0] row_address,   // 2-bit row address
    input wire enable,              // Enable signal
    input wire write_enable,        // Write enable
    input wire [3:0] data_in,       // Data input for write operations
    output wire [3:0] data_out,     // Data output for read operations
    output wire [3:0] word_lines_debug // Debug output to see word lines
);

wire [3:0] word_lines;
wire [3:0] bit_lines;

// Instantiate row decoder
row_decoder_2to4 row_decoder (
    .address(row_address),
    .enable(enable),
    .word_lines(word_lines)
);

// For simplicity, connect data_in directly to bit_lines
assign bit_lines = data_in;


// Instantiate SRAM array
sram_4x4 sram_array (
    .word_lines(word_lines),
    .bit_lines(bit_lines),
    .write_enable(write_enable),
    .data_out(data_out)
);

// Debug output
assign word_lines_debug = word_lines;

endmodule


module sram_4x4 (
    input wire [3:0] word_lines,    // Word lines from row decoder
    input wire [3:0] bit_lines,     // Bit lines for data input
    
    input wire write_enable,        // Write enable signal
    output wire [3:0] data_out      // Data output from selected row
);

// 4x4 memory array - each cell stores 1 bit (16 bits total)
reg [3:0] memory_array [3:0];

initial begin
    memory_array[0] = 4'b0001;
    memory_array[1] = 4'b0010;
    memory_array[2] = 4'b0100;
    memory_array[3] = 4'b1000;
end

// Read operation - output data from selected row
assign data_out = (word_lines[0]) ? memory_array[0] :
                  (word_lines[1]) ? memory_array[1] :
                  (word_lines[2]) ? memory_array[2] :
                  (word_lines[3]) ? memory_array[3] :
                  4'b0000; // Default when no word line is active

// Write operation - write data to selected row
always @(*) begin
    if (write_enable) begin
        case (word_lines)
            4'b0001: memory_array[0] = bit_lines;
            4'b0010: memory_array[1] = bit_lines;
            4'b0100: memory_array[2] = bit_lines;
            4'b1000: memory_array[3] = bit_lines;
            default: ; // No operation
        endcase
    end
end

endmodule


module row_decoder_2to4 (
    input wire [1:0] address,   // 2-bit row address (a1, a0)
    input wire enable,          // Enable signal
    output wire [3:0] word_lines // Word lines (w3 to w0)
);

// Each word line is active when address matches its row AND enable is high
assign word_lines[0] = enable & (address == 2'b00);
assign word_lines[1] = enable & (address == 2'b01);
assign word_lines[2] = enable & (address == 2'b10);
assign word_lines[3] = enable & (address == 2'b11);

endmodule
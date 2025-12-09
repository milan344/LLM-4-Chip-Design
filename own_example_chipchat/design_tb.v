`timescale 1ns/1ps

module tb_sram_system;

reg [1:0] row_address;
reg enable;
reg write_enable;
reg [3:0] data_in;
wire [3:0] data_out;
wire [3:0] word_lines_debug;

// Test control variables
integer pass_count = 0;
integer fail_count = 0;

// Instantiate the SRAM system
sram_system uut (
    .row_address(row_address),
    .enable(enable),
    .write_enable(write_enable),
    .data_in(data_in),
    .data_out(data_out),
    .word_lines_debug(word_lines_debug)
);

initial begin
    $display("=== 4x4 SRAM System Testbench ===");
    $display("");
    
    // Initialize all signals
    enable = 0;
    write_enable = 0;
    row_address = 2'b00;
    data_in = 4'h0;
    #5;
    
    // TEST 1: Check system disabled (enable = 0)
    $display("Test 1: System disabled");
    if (word_lines_debug == 4'b0000 && data_out == 4'h0) begin
        $display("PASS: No word lines active when disabled");
        pass_count = pass_count + 1;
    end else begin
        $display("FAIL: Expected word_lines=0000, data=0, Got word_lines=%b, data=%h", 
                 word_lines_debug, data_out);
        fail_count = fail_count + 1;
    end
    
    // Enable system for remaining tests
    enable = 1;
    write_enable = 0;
    #5;
    
    // TEST 2: Read initial data from all addresses
    $display("");
    $display("Test 2-5: Read initial data from each address");
    
    // Address 0
    row_address = 2'b00;
    #5;
    if (word_lines_debug == 4'b0001 && data_out == 4'b0001) begin
        $display("PASS: Address 0 - word_lines=0001, data=1");
        pass_count = pass_count + 1;
    end else begin
        $display("FAIL: Address 0 - Expected word_lines=0001, data=1, Got word_lines=%b, data=%h", 
                 word_lines_debug, data_out);
        fail_count = fail_count + 1;
    end
    
    // Address 1
    row_address = 2'b01;
    #5;
    if (word_lines_debug == 4'b0010 && data_out == 4'b0010) begin
        $display("PASS: Address 1 - word_lines=0010, data=2");
        pass_count = pass_count + 1;
    end else begin
        $display("FAIL: Address 1 - Expected word_lines=0010, data=2, Got word_lines=%b, data=%h", 
                 word_lines_debug, data_out);
        fail_count = fail_count + 1;
    end
    
    // Address 2
    row_address = 2'b10;
    #5;
    if (word_lines_debug == 4'b0100 && data_out == 4'b0100) begin
        $display("PASS: Address 2 - word_lines=0100, data=4");
        pass_count = pass_count + 1;
    end else begin
        $display("FAIL: Address 2 - Expected word_lines=0100, data=4, Got word_lines=%b, data=%h", 
                 word_lines_debug, data_out);
        fail_count = fail_count + 1;
    end
    
    // Address 3
    row_address = 2'b11;
    #5;
    if (word_lines_debug == 4'b1000 && data_out == 4'b1000) begin
        $display("PASS: Address 3 - word_lines=1000, data=8");
        pass_count = pass_count + 1;
    end else begin
        $display("FAIL: Address 3 - Expected word_lines=1000, data=8, Got word_lines=%b, data=%h", 
                 word_lines_debug, data_out);
        fail_count = fail_count + 1;
    end
    
    // TEST 3: Write new data to all addresses
    $display("");
    $display("Test 6-9: Write new data to each address");
    write_enable = 1;
    
    // Write A to address 0
    row_address = 2'b00;
    data_in = 4'hA;
    #5;
    if (word_lines_debug == 4'b0001 && data_out == 4'hA) begin
        $display("PASS: Write A to address 0");
        pass_count = pass_count + 1;
    end else begin
        $display("FAIL: Write A to address 0 - Got word_lines=%b, data=%h", 
                 word_lines_debug, data_out);
        fail_count = fail_count + 1;
    end
    
    // Write B to address 1
    row_address = 2'b01;
    data_in = 4'hB;
    #5;
    if (word_lines_debug == 4'b0010 && data_out == 4'hB) begin
        $display("PASS: Write B to address 1");
        pass_count = pass_count + 1;
    end else begin
        $display("FAIL: Write B to address 1 - Got word_lines=%b, data=%h", 
                 word_lines_debug, data_out);
        fail_count = fail_count + 1;
    end
    
    // Write C to address 2
    row_address = 2'b10;
    data_in = 4'hC;
    #5;
    if (word_lines_debug == 4'b0100 && data_out == 4'hC) begin
        $display("PASS: Write C to address 2");
        pass_count = pass_count + 1;
    end else begin
        $display("FAIL: Write C to address 2 - Got word_lines=%b, data=%h", 
                 word_lines_debug, data_out);
        fail_count = fail_count + 1;
    end
    
    // Write D to address 3
    row_address = 2'b11;
    data_in = 4'hD;
    #5;
    if (word_lines_debug == 4'b1000 && data_out == 4'hD) begin
        $display("PASS: Write D to address 3");
        pass_count = pass_count + 1;
    end else begin
        $display("FAIL: Write D to address 3 - Got word_lines=%b, data=%h", 
                 word_lines_debug, data_out);
        fail_count = fail_count + 1;
    end
    
    // TEST 4: Read back written data
    $display("");
    $display("Test 10-13: Read back written data");
    write_enable = 0;
    data_in = 4'h0; // Don't care for reads
    
    // Read A from address 0
    row_address = 2'b00;
    #5;
    if (data_out == 4'hA) begin
        $display("PASS: Read back A from address 0");
        pass_count = pass_count + 1;
    end else begin
        $display("FAIL: Read back from address 0 - Expected A, Got %h", data_out);
        fail_count = fail_count + 1;
    end
    
    // Read B from address 1
    row_address = 2'b01;
    #5;
    if (data_out == 4'hB) begin
        $display("PASS: Read back B from address 1");
        pass_count = pass_count + 1;
    end else begin
        $display("FAIL: Read back from address 1 - Expected B, Got %h", data_out);
        fail_count = fail_count + 1;
    end
    
    // Read C from address 2
    row_address = 2'b10;
    #5;
    if (data_out == 4'hC) begin
        $display("PASS: Read back C from address 2");
        pass_count = pass_count + 1;
    end else begin
        $display("FAIL: Read back from address 2 - Expected C, Got %h", data_out);
        fail_count = fail_count + 1;
    end
    
    // Read D from address 3
    row_address = 2'b11;
    #5;
    if (data_out == 4'hD) begin
        $display("PASS: Read back D from address 3");
        pass_count = pass_count + 1;
    end else begin
        $display("FAIL: Read back from address 3 - Expected D, Got %h", data_out);
        fail_count = fail_count + 1;
    end
    
    // TEST 5: Final disable test
    $display("");
    $display("Test 14: Final disable test");
    enable = 0;
    #5;
    if (word_lines_debug == 4'b0000) begin
        $display("PASS: System properly disabled");
        pass_count = pass_count + 1;
    end else begin
        $display("FAIL: System not disabled - word_lines=%b", word_lines_debug);
        fail_count = fail_count + 1;
    end
    
    // Final Results
    $display("");
    $display("=== FINAL RESULTS ===");
    $display("Tests Passed: %0d", pass_count);
    $display("Tests Failed: %0d", fail_count);
    $display("Total Tests:  %0d", pass_count + fail_count);
    
    if (fail_count == 0) begin
        $display("");
        $display("*** ALL TESTS PASSED! DESIGN IS CORRECT ***");
    end else begin
        $display("");
        $display("*** %0d TESTS FAILED - CHECK DESIGN ***", fail_count);
    end
    
    $finish;
end

// Generate VCD file for GTKWave
initial begin
    $dumpfile("sram_4x4_system.vcd");
    $dumpvars(0, tb_sram_system);
end

endmodule
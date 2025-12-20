`timescale 1 ps/1 ps
`define OK 12
`define INCORRECT 13

module reference_module(
    input clk,
    input reset_n,
    input data_in,
    input shift_enable,
    output reg [7:0] data_out
);
    // Reference implementation for 8-bit shift register
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            data_out <= 8'b0;
        end else if (shift_enable) begin
            data_out <= {data_out[6:0], data_in};
        end
    end
endmodule

module stimulus_gen (
    input clk,
    output reg reset_n,
    output reg data_in,
    output reg shift_enable,
    output reg[511:0] wavedrom_title,
    output reg wavedrom_enable
);

    // Test case data vectors
    reg [7:0] test_case_reset_n      = 8'b00111111;
    reg [7:0] test_case_data_in      = 8'b01011100;
    reg [7:0] test_case_shift_enable = 8'b10111010;

    task wavedrom_start(input[511:0] title = "");
    endtask
    
    task wavedrom_stop;
        #1;
    endtask

    initial begin
        int count; count = 0;
        reset_n <= 0;
        data_in <= 0;
        shift_enable <= 0;
        
        wavedrom_start("8-bit Shift Register");
        
        // Apply initial reset
        @(posedge clk);
        reset_n <= 1;
        
        // Run through test vectors
        repeat(7) @(posedge clk) begin
            reset_n <= test_case_reset_n[count];
            data_in <= test_case_data_in[count];
            shift_enable <= test_case_shift_enable[count];
            count = count + 1;
        end
        
        wavedrom_stop();

        // Additional random testing
        repeat(50) @(posedge clk,negedge clk) begin
            reset_n <= ($random % 10) != 0; // Reset 10% of the time
            data_in <= $random;
            shift_enable <= $random;
        end
        
        #1 $finish;
    end
    
endmodule

module tb();

    typedef struct packed {
        int errors;
        int errortime;
        int errors_data_out;
        int errortime_data_out;
        int clocks;
    } stats;
    
    stats stats1;
    
    wire[511:0] wavedrom_title;
    wire wavedrom_enable;
    int wavedrom_hide_after_time;
    
    reg clk=0;
    initial forever
        #5 clk = ~clk;

    logic reset_n;
    logic data_in;
    logic shift_enable;
    logic [7:0] data_out_ref;
    logic [7:0] data_out_dut;

    initial begin 
        $dumpfile("wave.vcd");
        $dumpvars(1, stim1.clk, tb_mismatch, reset_n, data_in, shift_enable, data_out_ref, data_out_dut);
    end

    wire tb_match;
    wire tb_mismatch = ~tb_match;
    
    stimulus_gen stim1 (
        .clk,
        .* ,
        .reset_n,
        .data_in,
        .shift_enable
    );
    
    reference_module good1 (
        .clk,
        .reset_n,
        .data_in,
        .shift_enable,
        .data_out(data_out_ref)
    );
        
    top_module top_module1 (
        .clk,
        .reset_n,
        .data_in,
        .shift_enable,
        .data_out(data_out_dut)
    );

    bit strobe = 0;
    task wait_for_end_of_timestep;
        repeat(5) begin
            strobe <= !strobe;
            @(strobe);
        end
    endtask

    final begin
        if (stats1.errors_data_out) $display("Hint: Output '%s' has %0d mismatches. First mismatch occurred at time %0d.", "data_out", stats1.errors_data_out, stats1.errortime_data_out);
        else $display("Hint: Output '%s' has no mismatches.", "data_out");

        $display("Hint: Total mismatched samples is %1d out of %1d samples\n", stats1.errors, stats1.clocks);
        $display("Simulation finished at %0d ps", $time);
        $display("Mismatches: %1d in %1d samples", stats1.errors, stats1.clocks);
    end
    
    // Verification: XORs on the right makes any X in good_vector match anything, but X in dut_vector will only match X.
    assign tb_match = ( data_out_ref === ( data_out_ref ^ data_out_dut ^ data_out_ref ) );
    
    always @(posedge clk, negedge clk) begin
        stats1.clocks++;
        if (!tb_match) begin
            if (stats1.errors == 0) stats1.errortime = $time;
            stats1.errors++;
        end
        if (data_out_ref !== ( data_out_ref ^ data_out_dut ^ data_out_ref ))
        begin 
            if (stats1.errors_data_out == 0) stats1.errortime_data_out = $time;
            stats1.errors_data_out = stats1.errors_data_out+1'b1; 
        end
    end
    
endmodule
`timescale 1 ps/1 ps
`define OK 12
`define INCORRECT 13

module reference_module(
    input clk,
    input reset_n,
    output reg [7:0] data
);
    // Reference implementation for 8-bit LFSR
    // Using polynomial x^8 + x^7 + x^6 + x^4 + x^1 + 1 (taps at positions 0, 3, 5, 6)
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            data <= 8'b10001010;  // Initial state
        end else begin
            data <= {data[6:0], data[0] ^ data[3] ^ data[5] ^ data[6]};
        end
    end
    
endmodule

module stimulus_gen (
    input clk,
    output reg reset_n,
    output reg[511:0] wavedrom_title,
    output reg wavedrom_enable
);

    task wavedrom_start(input[511:0] title = "");
    endtask
    
    task wavedrom_stop;
        #1;
    endtask

    initial begin
        int count; count = 0;
        reset_n <= 0;
        wavedrom_start("8-bit LFSR");
        
        // Apply reset
        repeat(2) @(posedge clk);
        reset_n <= 1;
        
        // Run for 256 cycles to test full sequence
        repeat(256) @(posedge clk) begin
            count = count + 1;
        end
        wavedrom_stop();

        // Additional testing with reset cycles
        repeat(50) @(posedge clk,negedge clk) begin
            if ($random % 20 == 0) begin  // Randomly assert reset
                reset_n <= 0;
                @(posedge clk);
                reset_n <= 1;
            end
        end
        
        #1 $finish;
    end
    
endmodule

module tb();

    typedef struct packed {
        int errors;
        int errortime;
        int errors_data;
        int errortime_data;
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
    logic [7:0] data_ref;
    logic [7:0] data_dut;

    initial begin 
        $dumpfile("wave.vcd");
        $dumpvars(1, stim1.clk, tb_mismatch, reset_n, data_ref, data_dut);
    end

    wire tb_match;
    wire tb_mismatch = ~tb_match;
    
    stimulus_gen stim1 (
        .clk,
        .* ,
        .reset_n
    );
    
    reference_module good1 (
        .clk,
        .reset_n,
        .data(data_ref)
    );
        
    top_module top_module1 (
        .clk,
        .reset_n,
        .data(data_dut)
    );

    bit strobe = 0;
    task wait_for_end_of_timestep;
        repeat(5) begin
            strobe <= !strobe;
            @(strobe);
        end
    endtask

    final begin
        if (stats1.errors_data) $display("Hint: Output '%s' has %0d mismatches. First mismatch occurred at time %0d.", "data", stats1.errors_data, stats1.errortime_data);
        else $display("Hint: Output '%s' has no mismatches.", "data");

        $display("Hint: Total mismatched samples is %1d out of %1d samples\n", stats1.errors, stats1.clocks);
        $display("Simulation finished at %0d ps", $time);
        $display("Mismatches: %1d in %1d samples", stats1.errors, stats1.clocks);
    end
    
    // Verification: XORs on the right makes any X in good_vector match anything, but X in dut_vector will only match X.
    assign tb_match = ( data_ref === ( data_ref ^ data_dut ^ data_ref ) );
    
    always @(posedge clk, negedge clk) begin
        stats1.clocks++;
        if (!tb_match) begin
            if (stats1.errors == 0) stats1.errortime = $time;
            stats1.errors++;
        end
        if (data_ref !== ( data_ref ^ data_dut ^ data_ref ))
        begin 
            if (stats1.errors_data == 0) stats1.errortime_data = $time;
            stats1.errors_data = stats1.errors_data+1'b1; 
        end
    end
    
endmodule
`timescale 1ns/1ps
module tb_comp4;
    reg  [3:0] A, B;
    wire gt, lt, eq;

    comp4 uut (.A(A), .B(B), .gt(gt), .lt(lt), .eq(eq));

    integer i, j;

    initial begin
        $display("Testing comp4 (4-bit comparator)");
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                A = i; B = j; #1;
                if ((A > B && gt) || (A < B && lt) || (A == B && eq))
                    $display("A=%0d, B=%0d => Passed!", A, B);
                else
                    $display("A=%0d, B=%0d => Failed!", A, B);
            end
        end
        $finish;
    end
endmodule

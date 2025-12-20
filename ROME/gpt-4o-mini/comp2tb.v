`timescale 1ns/1ps
module tb_comp2;
    reg  [1:0] A, B;
    wire gt, lt, eq;

    comp2 uut (.A(A), .B(B), .gt(gt), .lt(lt), .eq(eq));

    integer i, j;

    initial begin
        $display("Testing comp2 (2-bit comparator)");
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
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

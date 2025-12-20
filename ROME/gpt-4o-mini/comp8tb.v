`timescale 1ns/1ps
module tb_comp8;
    reg  [7:0] A, B;
    wire gt, lt, eq;

    comp8 uut (.A(A), .B(B), .gt(gt), .lt(lt), .eq(eq));

    integer k;

    initial begin
        $display("Testing comp8 (8-bit comparator)");
        // run 20 random tests
        for (k = 0; k < 20; k = k + 1) begin
            A = $random; B = $random; #1;
            if ((A > B && gt) || (A < B && lt) || (A == B && eq))
                $display("A=%0d, B=%0d => Passed!", A, B);
            else
                $display("A=%0d, B=%0d => Failed!", A, B);
        end
        $finish;
    end
endmodule

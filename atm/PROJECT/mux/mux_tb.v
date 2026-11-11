module mux2to1_tb;

reg A, B, S;
wire Y;

mux2to1 uut (
    .A(A),
    .B(B),
    .S(S),
    .Y(Y)
);

initial begin

    $monitor("S=%b A=%b B=%b Y=%b", S, A, B, Y);

    S=0; A=0; B=0; #10;
    S=0; A=0; B=1; #10;
    S=0; A=1; B=0; #10;
    S=0; A=1; B=1; #10;

    S=1; A=0; B=0; #10;
    S=1; A=0; B=1; #10;
    S=1; A=1; B=0; #10;
    S=1; A=1; B=1; #10;

    $finish;

end

endmodule
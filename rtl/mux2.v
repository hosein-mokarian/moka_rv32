module mux2
  #(parameter DATA_WIDTH = 32)
  (
    input rstn,
    input en,
    input sel,
    input [DATA_WIDTH - 1 : 0] a,
    input [DATA_WIDTH - 1 : 0] b,
    output [DATA_WIDTH - 1 : 0] y
  );

  assign y = (rstn && en) ? (sel ? b : a) : {DATA_WIDTH{1'b0}};

endmodule
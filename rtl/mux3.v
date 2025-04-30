module mux3
  #(parameter DATA_WIDTH = 32)
  (
    input rstn,
    input en,
    input [1 : 0] sel,
    input [DATA_WIDTH - 1 : 0] a,
    input [DATA_WIDTH - 1 : 0] b,
    input [DATA_WIDTH - 1 : 0] c,
    output reg [DATA_WIDTH - 1 : 0] y
  );

  always @(*)
  begin
    if (!rstn)
    begin
      y = 0;
    end
    else if (rstn && en)
    begin
      case (sel)
        2'b00: y = a;
        2'b01: y = b;
        2'b10: y = c;
      endcase
    end
  end

endmodule
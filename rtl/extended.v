module extended
  #(parameter DATA_WIDTH = 32)
  (
    input rstn,
    input en,
    input [DATA_WIDTH - 1 : 0] xin,
    input [1 : 0] ImmSrc,
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
      case (ImmSrc)
      2'b00: y = {{20{xin[31]}}, xin[31 : 20]};
      2'b01: y = {{20{xin[31]}}, xin[31 : 25], xin[11 : 7]};
      2'b10: y = {{20{xin[31]}}, xin[7], xin[30 : 25], xin[11 : 8], 1'b0};
      2'b11: y = {{12{xin[31]}}, xin[19:12], xin[20], xin[30:21], 1'b0};
      endcase
    end
  end

endmodule
module dff
  #(parameter DATA_WIDTH = 32)
  (
    input rstn,
    input en,
    input clk,
    input clr,
    input [DATA_WIDTH - 1 : 0] D,
    output reg [DATA_WIDTH - 1 : 0] Q
  );

  always @(posedge clk or negedge rstn)
  begin
    if (!rstn)
    begin
      Q <= 0;
    end
    else if (rstn && clr)
    begin
      Q <= 0;
    end
    else if (rstn && en)
    begin
      Q <= D;
    end
  end

endmodule
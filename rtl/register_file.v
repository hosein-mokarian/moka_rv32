module register_file
  #(parameter DATA_WIDTH = 32,
    parameter NB_OF_REGS = 32,
    parameter ADDRESS_BIT_WIDTH = 5)
  (
    input rstn,
    input en,
    input clk,
    input [ADDRESS_BIT_WIDTH -  1 : 0] A1,
    input [ADDRESS_BIT_WIDTH -  1 : 0] A2,
    input [ADDRESS_BIT_WIDTH -  1 : 0] A3,
    input [DATA_WIDTH -  1 : 0] WD3,
    input WE3,
    output [DATA_WIDTH - 1 : 0] RD1,
    output [DATA_WIDTH - 1 : 0] RD2
  );

  reg [DATA_WIDTH - 1 : 0] mem [NB_OF_REGS - 1 : 0];
  integer i;

  always @(negedge clk or negedge rstn)
  begin
    if (!rstn)
    begin
      for (i = 0; i < NB_OF_REGS; i = i + 1)
        mem[i] <= 0;
      
      mem[9] <= 'd10;
      mem[9] <= 'h2004;
    end
    else if (rstn && en)
    begin
      if (WD3 == 1)
        mem[A3] <= WD3;
    end
  end

  assign RD1 = (rstn && en) ? mem[A1] : {DATA_WIDTH{1'b0}};
  assign RD2 = (rstn && en) ? mem[A2] : {DATA_WIDTH{1'b0}};

endmodule
module instruction_memory
  #(parameter DATA_WIDTH = 32,
    parameter MEM_CAPACITY = 10
  )
  (
    input rstn,
    input en,
    input clk,
    input [DATA_WIDTH - 1 : 0] A,
    input [DATA_WIDTH - 1 : 0] WD,
    input WE,
    output [DATA_WIDTH - 1 : 0] RD
  );

  reg [DATA_WIDTH - 1 : 0] mem [MEM_CAPACITY - 1 : 0];

  integer i;

  always @(posedge clk or negedge rstn)
  begin
    if (!rstn)
    begin
      for (i = 0; i < MEM_CAPACITY; i = i + 1)
      begin
        mem[i] <= 32'hFFFFFFFF;
      end
    end
    else if (WE)
    begin
      mem[A] <= WD;
    end
  end

  assign RD = (rstn && en && !WE) ? mem[A] : {DATA_WIDTH{1'b0}};

endmodule
module instruction_memory
  #(parameter DATA_WIDTH = 32,
    parameter MEM_CAPACITY = 10
  )
  (
    input rstn,
    input en,
    input [DATA_WIDTH - 1 : 0] A,
    output [DATA_WIDTH - 1 : 0] RD
  );

  reg [DATA_WIDTH - 1 : 0] mem [MEM_CAPACITY - 1 : 0];

  always @(negedge rstn)
  begin
    if (!rstn)
    begin
      mem[0] <= 'hFFC4A303;
      mem[1] <= 'h0064A423;
      mem[2] <= 'h0062E233;
      mem[3] <= 'hFE420AE3;
    end
  end

  assign RD = (rstn && en) ? mem[A] : {DATA_WIDTH{1'b0}};

endmodule
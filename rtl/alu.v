module alu
  #(parameter DATA_WIDTH = 32)
  (
    input rstn,
    input en,
    input signed [DATA_WIDTH - 1 : 0] srca,
    input signed [DATA_WIDTH - 1 : 0] srcb,
    input [2 : 0] control,
    output zero,
    output reg signed [DATA_WIDTH - 1 : 0] y
  );

  localparam OP_ADD = 3'b000;
  localparam OP_SUB = 3'b001;
  localparam OP_AND = 3'b010;
  localparam OP_OR  = 3'b011;

  localparam OP_SLT = 3'b101;

  always @(*)
  begin
    if (!rstn)
    begin
      y = 0;
    end
    else if (rstn && en)
    begin
      case (control)
      OP_ADD: y = srca + srcb;
      OP_SUB: y = srca - srcb;
      OP_AND: y = srca & srcb;
      OP_OR : y = srca | srca;

      OP_SLT: y = (srca < srcb) ? srca : y;
      endcase
    end
  end

endmodule
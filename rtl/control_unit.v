module control_unit
  #(parameter DATA_WIDTH = 32)
  (
    input rstn,
    input en,
    input clk,
    input [6 : 0] op,
    input [2 : 0] funct3,
    input funct7,
    output reg RegWrite,
    output reg [1 : 0] ImmSrc,
    output reg ALUSrc,
    output reg [2 : 0] ALUControl,
    output reg MemWrite,
    output reg [1: 0] ResultSrc,
    output reg Branch,
    output reg Jump
  );

  localparam lw = 7'b0000011;
  localparam sw = 7'b0100011;
  localparam R_type = 7'b0110011;
  localparam beq = 7'b1100011;
  localparam addi = 7'b0010011;
  localparam jal = 7'b1101111;

  localparam OP_ADD = 3'b000;
  localparam OP_SUB = 3'b001;
  localparam OP_AND = 3'b010;
  localparam OP_OR  = 3'b011;
  localparam OP_SLT = 3'b101;

  reg [2 : 0] ALUOp;
  wire op_5;
  wire [2 : 0] func3_2_0;
  wire funct7_5;

  // assign ALUOp = (rstn && en) ? op[2 : 0] : 3'b000;
  assign op_5 = (rstn && en) ? op[5] : 1'b0;
  assign func3_2_0 = (rstn && en) ? funct3 : 3'b000;
  assign funct7_5 = (rstn && en) ? funct7 : 1'b0;


  // Main Decoder
  always @(*)
  begin
    if (!rstn)
    begin
      RegWrite = 0;
      ImmSrc = 2'b00;
      ALUSrc = 0;
      MemWrite = 0;
      ResultSrc = 2'b00;
      Branch = 0;
      ALUOp = 2'b00;
      Jump = 0;
    end
    else if (rstn && en)
    begin
      case (op)
        lw:
        begin
          RegWrite = 1;
          ImmSrc = 2'b00;
          ALUSrc = 1;
          MemWrite = 0;
          ResultSrc = 2'b01;
          Branch = 0;
          ALUOp = 2'b00;
          Jump = 0;
        end
        sw:
        begin
          RegWrite = 0;
          ImmSrc = 2'b01;
          ALUSrc = 1;
          MemWrite = 1;
          ResultSrc = 2'bxx;
          Branch = 0;
          ALUOp = 2'b00;
          Jump = 0;
        end
        R_type:
        begin
          RegWrite = 1;
          ImmSrc = 2'bxx;
          ALUSrc = 0;
          MemWrite = 0;
          ResultSrc = 2'b00;
          Branch = 0;
          ALUOp = 2'b10;
          Jump = 0;
        end
        beq:
        begin
          RegWrite = 0;
          ImmSrc = 2'b10;
          ALUSrc = 0;
          MemWrite = 0;
          ResultSrc = 2'bxx;
          Branch = 1;
          ALUOp = 2'b01;
          Jump = 0;
        end
        addi:
        begin
          RegWrite = 1;
          ImmSrc = 2'b00;
          ALUSrc = 1;
          MemWrite = 0;
          ResultSrc = 2'b00;
          Branch = 0;
          ALUOp = 2'b10;
          Jump = 0;
        end
        jal:
        begin
          RegWrite = 1;
          ImmSrc = 2'b11;
          ALUSrc = 1'bx;
          MemWrite = 0;
          ResultSrc = 2'b10;
          Branch = 0;
          ALUOp = 2'bxx;
          Jump = 1;
        end
      endcase
    end
  end


  // ALU Decoder
  always @(*)
  begin
    if (!rstn)
    begin
      ALUControl = 0;
    end
    else if (rstn && en)
    begin
      case (ALUOp)
        3'b010:
        begin
          case (func3_2_0)
            3'b000:
            begin
              case ({op_5, funct7_5})
                2'b00,
                2'b01,
                2'b10:
                  ALUControl = OP_ADD;
                2'b11:
                  ALUControl = OP_SUB;
              endcase
            end
            3'b010: ALUControl = OP_SLT;
            3'b110: ALUControl = OP_OR;
            3'b111: ALUControl = OP_AND;
          endcase
        end
      endcase
    end
  end

endmodule
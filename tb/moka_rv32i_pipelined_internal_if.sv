interface moka_rv32i_pipelined_internal_if
#(
    parameter DATA_WIDTH = 32
);

  //--- FETCH ---
  logic [DATA_WIDTH - 1 : 0] PCNext;
  logic [DATA_WIDTH - 1 : 0] PCF;
  logic [DATA_WIDTH - 1 : 0] PCPlus4F;
  logic [DATA_WIDTH - 1 : 0] InstrF;
  logic [DATA_WIDTH - 1 : 0] instr_mem_addr;

  //--- DECODE ---
  logic [DATA_WIDTH - 1 : 0] InstrD;
  logic [DATA_WIDTH - 1 : 0] PCD;
  logic [DATA_WIDTH - 1 : 0] PCPlus4D;

  logic [6 : 0] op;
  logic [2 : 0] funct3;
  logic funct7;
  logic [4 : 0] Rs1D;
  logic [4 : 0] Rs2D;
  logic [4 : 0] RdD;
  logic [DATA_WIDTH - 1 : 0] Immidate;
  logic [DATA_WIDTH - 1 : 0] ImmExtD;
  logic [DATA_WIDTH - 1 : 0] RD1D;
  logic [DATA_WIDTH - 1 : 0] RD2D;

  //--- EXECUTE ---
  logic [DATA_WIDTH - 1 : 0] PCE;
  logic [DATA_WIDTH - 1 : 0] PCPlus4E;
  logic [4 : 0] Rs1E;
  logic [4 : 0] Rs2E;
  logic [4 : 0] RdE;
  logic [DATA_WIDTH - 1 : 0] ImmExtE;
  logic [DATA_WIDTH - 1 : 0] RD1E;
  logic [DATA_WIDTH - 1 : 0] RD2E;
  logic [DATA_WIDTH - 1 : 0] WritDataE;

  logic [DATA_WIDTH - 1 : 0] SrcAE;
  logic [DATA_WIDTH - 1 : 0] SrcBE;
  logic zeroE;
  logic [DATA_WIDTH - 1 : 0] ALUResultE;

  logic [DATA_WIDTH - 1 : 0] PCTargetE;

  //--- MEMORY ---
  logic [4 : 0] RdM;
  logic [DATA_WIDTH - 1 : 0] ALUResultM;
  logic [DATA_WIDTH - 1 : 0] WritDataM;
  logic [DATA_WIDTH - 1 : 0] PCPlus4M;

  logic [DATA_WIDTH - 1 : 0] ReadDateM;

  //--- WRITEBACK ---
  logic [4 : 0] RdW;
  logic [DATA_WIDTH - 1 : 0] ALUResultW;
  logic [DATA_WIDTH - 1 : 0] ReadDateW;
  logic [DATA_WIDTH - 1 : 0] PCPlus4W;

  logic [DATA_WIDTH - 1 : 0] ResultW;

  //--- control unit ---
  logic RegWriteD;
  logic [1 : 0] ImmSrcD;
  logic ALUSrcD;
  logic [2 : 0] ALUControlD;
  logic MemWriteD;
  logic [1 : 0] ResultSrcD;
  logic BranchD;
  logic JumpD;

  logic PCSrcE;
  logic RegWriteE;
  logic ALUSrcE;
  logic [2 : 0] ALUControlE;
  logic MemWriteE;
  logic [1 : 0] ResultSrcE;
  logic BranchE;
  logic JumpE;

  logic RegWriteM;
  logic MemWriteM;
  logic [1 : 0] ResultSrcM;

  logic RegWriteW;
  logic [1 : 0] ResultSrcW;

  //--- hazard unit ---
  logic [1 : 0] ForwardAE;
  logic [1 : 0] ForwardBE;
  logic [DATA_WIDTH - 1 : 0] Forwarded_SrcB;
  logic StallF;
  logic StallD;
  logic FlushD;
  logic FlushE;

endinterface
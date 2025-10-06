`include "dff.v"
`include "mux2.v"
`include "adder.v"
`include "instruction_memory.v"
`include "register_file.v"
`include "extended.v"
`include "alu.v"
`include "data_memory.v"
`include "mux3.v"
`include "control_unit.v"
`include "hazard_unit.v"


module moka_top
  #(parameter DATA_WIDTH = 32)
  (
    input rstn,
    input en,
    input clk,
    input [DATA_WIDTH - 1 : 0] instr_mem_address,
    input [DATA_WIDTH - 1 : 0] instr_mem_write_data,
    input instr_mem_we
  );


  parameter NB_OF_REGS = 32;
  parameter ADDRESS_BIT_WIDTH = 5;
  parameter INSTR_MEM_CAPACITY = 1024;
  parameter DATA_MEM_CAPACITY = 10 * 1024;


  //--- FETCH ---
  wire [DATA_WIDTH - 1 : 0] PCNext;
  wire [DATA_WIDTH - 1 : 0] PCF;
  wire [DATA_WIDTH - 1 : 0] PCPlus4F;
  wire [DATA_WIDTH - 1 : 0] InstrF;
  wire [DATA_WIDTH - 1 : 0] instr_mem_addr;

  //--- DECODE ---
  wire [DATA_WIDTH - 1 : 0] InstrD;
  wire [DATA_WIDTH - 1 : 0] PCD;
  wire [DATA_WIDTH - 1 : 0] PCPlus4D;

  wire [6 : 0] op;
  wire [2 : 0] funct3;
  wire funct7;
  wire [4 : 0] Rs1D;
  wire [4 : 0] Rs2D;
  wire [4 : 0] RdD;
  wire [DATA_WIDTH - 1 : 0] Immidate;
  wire [DATA_WIDTH - 1 : 0] ImmExtD;
  wire [DATA_WIDTH - 1 : 0] RD1D;
  wire [DATA_WIDTH - 1 : 0] RD2D;

  //--- EXECUTE ---
  wire [DATA_WIDTH - 1 : 0] PCE;
  wire [DATA_WIDTH - 1 : 0] PCPlus4E;
  wire [4 : 0] Rs1E;
  wire [4 : 0] Rs2E;
  wire [4 : 0] RdE;
  wire [DATA_WIDTH - 1 : 0] ImmExtE;
  wire [DATA_WIDTH - 1 : 0] RD1E;
  wire [DATA_WIDTH - 1 : 0] RD2E;
  wire [DATA_WIDTH - 1 : 0] WritDataE;

  wire [DATA_WIDTH - 1 : 0] SrcAE;
  wire [DATA_WIDTH - 1 : 0] SrcBE;
  wire zeroE;
  wire [DATA_WIDTH - 1 : 0] ALUResultE;

  wire [DATA_WIDTH - 1 : 0] PCTargetE;

  //--- MEMORY ---
  wire [4 : 0] RdM;
  wire [DATA_WIDTH - 1 : 0] ALUResultM;
  wire [DATA_WIDTH - 1 : 0] WritDataM;
  wire [DATA_WIDTH - 1 : 0] PCPlus4M;

  wire [DATA_WIDTH - 1 : 0] ReadDateM;

  //--- WRITEBACK ---
  wire [4 : 0] RdW;
  wire [DATA_WIDTH - 1 : 0] ALUResultW;
  wire [DATA_WIDTH - 1 : 0] ReadDateW;
  wire [DATA_WIDTH - 1 : 0] PCPlus4W;

  wire [DATA_WIDTH - 1 : 0] ResultW;

  //--- control unit ---
  wire RegWriteD;
  wire [1 : 0] ImmSrcD;
  wire ALUSrcD;
  wire [2 : 0] ALUControlD;
  wire MemWriteD;
  wire [1 : 0] ResultSrcD;
  wire BranchD;
  wire JumpD;

  wire PCSrcE;
  wire RegWriteE;
  wire ALUSrcE;
  wire [2 : 0] ALUControlE;
  wire MemWriteE;
  wire [1 : 0] ResultSrcE;
  wire BranchE;
  wire JumpE;

  wire RegWriteM;
  wire MemWriteM;
  wire [1 : 0] ResultSrcM;

  wire RegWriteW;
  wire [1 : 0] ResultSrcW;

  //--- hazard unit ---
  wire [1 : 0] ForwardAE;
  wire [1 : 0] ForwardBE;
  wire [DATA_WIDTH - 1 : 0] Forwarded_SrcB;
  wire StallF;
  wire StallD;
  wire FlushD;
  wire FlushE;



  //--- FETCH ---
  mux2
  #(.DATA_WIDTH(DATA_WIDTH))
  MUX2_PC
  (
    .rstn(rstn),
    .en(en),
    .sel(PCSrcE),
    .a(PCPlus4F),
    .b(PCTargetE),
    .y(PCNext)
  );


  dff
  #(.DATA_WIDTH(DATA_WIDTH))
  DFF_PCF
  (
    .rstn(rstn),
    .en(en | StallF),
    .clk(clk),
    .clr(1'b0),
    .D(PCNext),
    .Q(PCF)
  );


  adder
  #(.DATA_WIDTH(DATA_WIDTH))
  ADDER_PC
  (
    .rstn(rstn),
    .en(en),
    .a(PCF),
    .b(32'h4),
    .y(PCPlus4F)
  );


  mux2
  #(.DATA_WIDTH(DATA_WIDTH))
  INSTR_MEM_MUX
  (
    .rstn(rstn),
    .en(1),
    .sel(instr_mem_we),
    .a(PCF),
    .b(instr_mem_address),
    .y(instr_mem_addr)
  );


  instruction_memory
  #(.DATA_WIDTH(DATA_WIDTH),
    .MEM_CAPACITY(INSTR_MEM_CAPACITY)
  )
  INSTR_MEM
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .A(instr_mem_addr),
    .WD(instr_mem_write_data),
    .WE(instr_mem_we),
    .RD(InstrF)
  );


  //--- DECODE ---
  dff
  #(.DATA_WIDTH(DATA_WIDTH))
  DFF_INSTR
  (
    .rstn(rstn),
    .en(en | StallD),
    .clk(clk),
    .clr(FlushD),
    .D(InstrF),
    .Q(InstrD)
  );

  dff
  #(.DATA_WIDTH(DATA_WIDTH))
  DFF_PCD
  (
    .rstn(rstn),
    .en(en | StallD),
    .clk(clk),
    .clr(FlushD),
    .D(PCF),
    .Q(PCD)
  );

  dff
  #(.DATA_WIDTH(DATA_WIDTH))
  DFF_PCPlus4D
  (
    .rstn(rstn),
    .en(en | StallD),
    .clk(clk),
    .clr(FlushD),
    .D(PCPlus4F),
    .Q(PCPlus4D)
  );

  
  assign op = (rstn && en) ? InstrD[6 : 0] : 7'b0;
  assign funct3 = (rstn && en) ? InstrD[14 : 12] : 3'b0;
  assign funct7 = (rstn && en) ? InstrD[30] : 1'b0;
  assign Rs1D = (rstn && en) ? InstrD[19 : 15] : 5'b0;
  assign Rs2D = (rstn && en) ? InstrD[24 : 20] : 5'b0;
  // assign rd = (rstn && en) ? InstrD[11 : 7] : 5'b0;
  assign Immidate = (rstn && en) ? {InstrD[31 : 7], 7'b0} : {DATA_WIDTH{1'b0}};


  dff
  #(.DATA_WIDTH(5))
  DFF_RdD
  (
    .rstn(rstn),
    .en(en | StallD),
    .clk(clk),
    .clr(FlushD),
    .D(InstrD[11 : 7]),
    .Q(RdD)
  );


  register_file
  #(.DATA_WIDTH(DATA_WIDTH),
    .NB_OF_REGS(NB_OF_REGS),
    .ADDRESS_BIT_WIDTH(ADDRESS_BIT_WIDTH)
  )
  REG_FILE
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .A1(Rs1D),
    .A2(Rs2D),
    .A3(RdW),
    .WD3(ResultW),
    .WE3(RegWriteW),
    .RD1(RD1D),
    .RD2(RD2D)
  );


  extended
  #(.DATA_WIDTH(DATA_WIDTH))
  EXT
  (
    .rstn(rstn),
    .en(en),
    .xin(Immidate),
    .ImmSrc(ImmSrcD),
    .y(ImmExtD)
  );


  //--- EXECUTE ---
  dff
  #(.DATA_WIDTH(DATA_WIDTH))
  DFF_RD1
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(FlushE),
    .D(RD1D),
    .Q(RD1E)
  );


  dff
  #(.DATA_WIDTH(DATA_WIDTH))
  DFF_RD2
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(FlushE),
    .D(RD2D),
    .Q(RD2E)
  );


  assign WritDataE = (rstn && en) ? RD2E : {DATA_WIDTH{1'b0}};


  dff
  #(.DATA_WIDTH(5))
  DFF_Rs1E
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(FlushE),
    .D(Rs1D),
    .Q(Rs1E)
  );


  dff
  #(.DATA_WIDTH(5))
  DFF_Rs2E
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(FlushE),
    .D(Rs2D),
    .Q(Rs2E)
  );


  dff
  #(.DATA_WIDTH(5))
  DFF_RdE
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(FlushE),
    .D(RdD),
    .Q(RdE)
  );


  dff
  #(.DATA_WIDTH(DATA_WIDTH))
  DFF_ImmExt
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(FlushE),
    .D(ImmExtD),
    .Q(ImmExtE)
  );


  dff
  #(.DATA_WIDTH(DATA_WIDTH))
  DFF_PCE
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(FlushE),
    .D(PCD),
    .Q(PCE)
  );


  dff
  #(.DATA_WIDTH(DATA_WIDTH))
  DFF_PCPlus4E
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(FlushE),
    .D(PCPlus4D),
    .Q(PCPlus4E)
  );


  mux3
  #(.DATA_WIDTH(DATA_WIDTH))
  MUX3_SrcAE
  (
    .rstn(rstn),
    .en(en),
    .sel(ForwardAE),
    .a(RD1E),
    .b(ReadDateW),
    .c(ALUResultM),
    .y(SrcAE)
  );


  mux3
  #(.DATA_WIDTH(DATA_WIDTH))
  MUX3_SrcBE
  (
    .rstn(rstn),
    .en(en),
    .sel(ForwardBE),
    .a(RD2E),
    .b(ReadDateW),
    .c(ALUResultM),
    .y(Forwarded_SrcB)
  );


  mux2
  #(.DATA_WIDTH(DATA_WIDTH))
  MUX2_RD2
  (
    .rstn(rstn),
    .en(en),
    .sel(ALUSrcE),
    .a(Forwarded_SrcB),
    .b(ImmExtE),
    .y(SrcBE)
  );


  alu
  #(.DATA_WIDTH(DATA_WIDTH))
  ALU
  (
    .rstn(rstn),
    .en(en),
    .srca(SrcAE),
    .srcb(SrcBE),
    .control(ALUControlE),
    .zero(zeroE),
    .y(ALUResultE)
  );


  adder
  #(.DATA_WIDTH(DATA_WIDTH))
  ADDER_PCTarget
  (
    .rstn(rstn),
    .en(en),
    .a(PCE),
    .b(ImmExtE),
    .y(PCTargetE)
  );


  //--- MEMORY ---
  dff
  #(.DATA_WIDTH(5))
  DFF_RdM
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(RdE),
    .Q(RdM)
  );


  dff
  #(.DATA_WIDTH(DATA_WIDTH))
  DFF_ALUResult
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(ALUResultE),
    .Q(ALUResultM)
  );


  dff
  #(.DATA_WIDTH(DATA_WIDTH))
  DFF_WriteDataE
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(WritDataE),
    .Q(WritDataM)
  );


  dff
  #(.DATA_WIDTH(DATA_WIDTH))
  DFF_PCPlus4M
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(PCPlus4E),
    .Q(PCPlus4M)
  );


  data_memory
  #(.DATA_WIDTH(DATA_WIDTH),
    .MEM_CAPACITY(DATA_MEM_CAPACITY)
  )
  DATA_MEM
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .A(ALUResultM),
    .WD(WritDataM),
    .WE(MemWriteM),
    .RD(ReadDateM)
  );


  //--- WRITEBACK ---
  dff
  #(.DATA_WIDTH(5))
  DFF_RdW
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(RdM),
    .Q(RdW)
  );


  dff
  #(.DATA_WIDTH(DATA_WIDTH))
  DFF_ALUResultW
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(ALUResultM),
    .Q(ALUResultW)
  );


  dff
  #(.DATA_WIDTH(DATA_WIDTH))
  DFF_ReadDataM
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(ReadDateM),
    .Q(ReadDateW)
  );


  dff
  #(.DATA_WIDTH(DATA_WIDTH))
  DFF_PCPlus4W
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(PCPlus4M),
    .Q(PCPlus4W)
  );


  mux3
  #(.DATA_WIDTH(DATA_WIDTH))
  MUX3_Result
  (
    .rstn(rstn),
    .en(en),
    .sel(ResultSrcW),
    .a(ALUResultW),
    .b(ReadDateW),
    .c(PCPlus4W),
    .y(ResultW)
  );


  //--- control unit ---
  control_unit
  #(.DATA_WIDTH(DATA_WIDTH))
  CU
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .op(op),
    .funct3(funct3),
    .funct7(funct7),
    .RegWrite(RegWriteD),
    .ImmSrc(ImmSrcD),
    .ALUSrc(ALUSrcD),
    .ALUControl(ALUControlD),
    .MemWrite(MemWriteD),
    .ResultSrc(ResultSrcD),
    .Branch(BranchD),
    .Jump(JumpD)
  );


  dff
  #(.DATA_WIDTH(1))
  DFF_RegWriteE
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(RegWriteD),
    .Q(RegWriteE)
  );

  dff
  #(.DATA_WIDTH(1))
  DFF_ALUSrcE
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(ALUSrcD),
    .Q(ALUSrcE)
  );

  dff
  #(.DATA_WIDTH(3))
  DFF_ALUControlE
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(ALUControlD),
    .Q(ALUControlE)
  );

  dff
  #(.DATA_WIDTH(1))
  DFF_MemWriteE
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(MemWriteD),
    .Q(MemWriteE)
  );

  dff
  #(.DATA_WIDTH(2))
  DFF_ResultSrcE
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(ResultSrcD),
    .Q(ResultSrcE)
  );

  dff
  #(.DATA_WIDTH(1))
  DFF_BranchE
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(BranchD),
    .Q(BranchE)
  );

  dff
  #(.DATA_WIDTH(1))
  DFF_JumpE
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(JumpD),
    .Q(JumpE)
  );


  assign PCSrcE = (rstn && en) ? ((BranchE & zeroE) | JumpE) : 1'b0;


  dff
  #(.DATA_WIDTH(1))
  DFF_RegWriteM
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(RegWriteE),
    .Q(RegWriteM)
  );

  dff
  #(.DATA_WIDTH(1))
  DFF_MemWriteM
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(MemWriteE),
    .Q(MemWriteM)
  );

  dff
  #(.DATA_WIDTH(2))
  DFF_ResultSrcM
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(ResultSrcE),
    .Q(ResultSrcM)
  );


  dff
  #(.DATA_WIDTH(DATA_WIDTH))
  DFF_RegWriteW
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(ReadDateM),
    .Q(ReadDateW)
  );

  dff
  #(.DATA_WIDTH(2))
  DFF_ResultSrcW
  (
    .rstn(rstn),
    .en(en),
    .clk(clk),
    .clr(1'b0),
    .D(ResultSrcM),
    .Q(ResultSrcW)
  );


  hazard_unit
  #(.DATA_WIDTH(DATA_WIDTH))
  HU
  (
    .rstn(rstn),
    .en(en),
    .Rs1D(Rs1D),
    .Rs2D(Rs2D),
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .RdE(RdE),
    .RdM(RdM),
    .RdW(RdW),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .ResultSrcE0(ResultSrcE[0]),
    .PCSrcE(PCSrcE),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
    .StallF(StallF),
    .StallD(StallD),
    .FlushD(FlushD),
    .FlushE(FlushE)
  );


endmodule
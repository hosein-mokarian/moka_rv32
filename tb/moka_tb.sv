`timescale 1ns/100ps


module moka_tb;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import moka_test_pkg::*;

  localparam DATA_WIDTH = 32;

  bit clk = 0;
  always #5 clk = ~clk;

  moka_rv32i_pipelined_if #(.DATA_WIDTH(DATA_WIDTH)) vif(clk);
  moka_rv32i_pipelined_internal_if#(.DATA_WIDTH(DATA_WIDTH)) internal_vif();

  moka_top #(
    .DATA_WIDTH(DATA_WIDTH)
  )
  dut (
    .rstn(vif.rstn),
    .en(vif.en),
    .clk(clk),
    .instr_mem_address(vif.instr_mem_address),
    .instr_mem_write_data(vif.instr_mem_write_data),
    .instr_mem_we(vif.instr_mem_we)
  );

  bind moka_top moka_rv32i_pipelined_internal_bind
  #(
    .DATA_WIDTH(DATA_WIDTH)
  )
  internal_monitor
  (
    //--- FETCH ---
    .PCNext(PCNext),
    .PCF(PCF),
    .PCPlus4F(PCPlus4F),
    .InstrF(InstrF),
    .instr_mem_addr(instr_mem_addr),

    //--- DECODE ---
    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D),

    .op(op),
    .funct3(funct3),
    .funct7(funct7),
    .Rs1D(Rs1D),
    .Rs2D(Rs2D),
    .RdD(RdD),
    .Immidate(Immidate),
    .ImmExtD(ImmExtD),
    .RD1D(RD1D),
    .RD2D(RD2D),

    //--- EXECUTE ---
    .PCE(PCE),
    .PCPlus4E(PCPlus4E),
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .RdE(RdE),
    .ImmExtE(ImmExtE),
    .RD1E(RD1E),
    .RD2E(RD2E),
    .WritDataE(WritDataE),

    .SrcAE(SrcAE),
    .SrcBE(SrcBE),
    .zeroE(zeroE),
    .ALUResultE(ALUResultE),

    .PCTargetE(PCTargetE),

    //--- MEMORY ---
    .RdM(RdM),
    .ALUResultM(ALUResultM),
    .WritDataM(WritDataM),
    .PCPlus4M(PCPlus4M),

    .ReadDateM(ReadDateM),

    //--- WRITEBACK ---
    .RdW(RdW),
    .ALUResultW(ALUResultW),
    .ReadDateW(ReadDateW),
    .PCPlus4W(PCPlus4W),

    .ResultW(ResultW),

    //--- control unit ---
    .RegWriteD(RegWriteD),
    .ImmSrcD(ImmSrcD),
    .ALUSrcD(ALUSrcD),
    .ALUControlD(ALUControlD),
    .MemWriteD(MemWriteD),
    .ResultSrcD(ResultSrcD),
    .BranchD(BranchD),
    .JumpD(JumpD),

    .PCSrcE(PCSrcE),
    .RegWriteE(RegWriteE),
    .ALUSrcE(ALUSrcE),
    .ALUControlE(ALUControlE),
    .MemWriteE(MemWriteE),
    .ResultSrcE(ResultSrcE),
    .BranchE(BranchE),
    .JumpE(JumpE),

    .RegWriteM(RegWriteM),
    .MemWriteM(MemWriteM),
    .ResultSrcM(ResultSrcM),

    .RegWriteW(RegWriteW),
    .ResultSrcW(ResultSrcW),

    //--- hazard unit ---
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
    .Forwarded_SrcB(Forwarded_SrcB),
    .StallF(StallF),
    .StallD(StallD),
    .FlushD(FlushD),
    .FlushE(FlushE)
  );

  //--- FETCH ---
  assign internal_vif.PCNext = dut.internal_monitor.PCNext;
  assign internal_vif.PCF = dut.internal_monitor.PCF;
  assign internal_vif.PCPlus4F = dut.internal_monitor.PCPlus4F;
  assign internal_vif.InstrF = dut.internal_monitor.InstrF;
  assign internal_vif.instr_mem_addr = dut.internal_monitor.instr_mem_addr;

  //--- DECODE ---
  assign internal_vif.InstrD = dut.internal_monitor.InstrD;
  assign internal_vif.PCD = dut.internal_monitor.PCD;
  assign internal_vif.PCPlus4D = dut.internal_monitor.PCPlus4D;

  assign internal_vif.op = dut.internal_monitor.op;
  assign internal_vif.funct3 = dut.internal_monitor.funct3;
  assign internal_vif.funct7 = dut.internal_monitor.funct7;
  assign internal_vif.Rs1D = dut.internal_monitor.Rs1D;
  assign internal_vif.Rs2D = dut.internal_monitor.Rs2D;
  assign internal_vif.RdD = dut.internal_monitor.RdD;
  assign internal_vif.Immidate = dut.internal_monitor.Immidate;
  assign internal_vif.ImmExtD = dut.internal_monitor.ImmExtD;
  assign internal_vif.RD1D = dut.internal_monitor.RD1D;
  assign internal_vif.RD2D = dut.internal_monitor.RD2D;

  //--- EXECUTE ---
  assign internal_vif.PCE = dut.internal_monitor.PCE;
  assign internal_vif.PCPlus4E = dut.internal_monitor.PCPlus4E;
  assign internal_vif.Rs1E = dut.internal_monitor.Rs1E;
  assign internal_vif.Rs2E = dut.internal_monitor.Rs2E;
  assign internal_vif.RdE = dut.internal_monitor.RdE;
  assign internal_vif.ImmExtE = dut.internal_monitor.ImmExtE;
  assign internal_vif.RD1E = dut.internal_monitor.RD1E;
  assign internal_vif.RD2E = dut.internal_monitor.RD2E;
  assign internal_vif.WritDataE = dut.internal_monitor.WritDataE;

  assign internal_vif.SrcAE = dut.internal_monitor.SrcAE;
  assign internal_vif.SrcBE = dut.internal_monitor.SrcBE;
  assign internal_vif.zeroE = dut.internal_monitor.zeroE;
  assign internal_vif.ALUResultE = dut.internal_monitor.ALUResultE;

  assign internal_vif.PCTargetE = dut.internal_monitor.PCTargetE;

  //--- MEMORY ---
  assign internal_vif.RdM = dut.internal_monitor.RdM;
  assign internal_vif.ALUResultM = dut.internal_monitor.ALUResultM;
  assign internal_vif.WritDataM = dut.internal_monitor.WritDataM;
  assign internal_vif.PCPlus4M = dut.internal_monitor.PCPlus4M;

  assign internal_vif.ReadDateM = dut.internal_monitor.ReadDateM;

  //--- WRITEBACK ---
  assign internal_vif.RdW = dut.internal_monitor.RdW;
  assign internal_vif.ALUResultW = dut.internal_monitor.ALUResultW;
  assign internal_vif.ReadDateW = dut.internal_monitor.ReadDateW;
  assign internal_vif.PCPlus4W = dut.internal_monitor.PCPlus4W;

  assign internal_vif.ResultW = dut.internal_monitor.ResultW;

  //--- control unit ---
  assign internal_vif.RegWriteD = dut.internal_monitor.RegWriteD;
  assign internal_vif.ImmSrcD = dut.internal_monitor.ImmSrcD;
  assign internal_vif.ALUSrcD = dut.internal_monitor.ALUSrcD;
  assign internal_vif.ALUControlD = dut.internal_monitor.ALUControlD;
  assign internal_vif.MemWriteD = dut.internal_monitor.MemWriteD;
  assign internal_vif.ResultSrcD = dut.internal_monitor.ResultSrcD;
  assign internal_vif.BranchD = dut.internal_monitor.BranchD;
  assign internal_vif.JumpD = dut.internal_monitor.JumpD;

  assign internal_vif.PCSrcE = dut.internal_monitor.PCSrcE;
  assign internal_vif.RegWriteE = dut.internal_monitor.RegWriteE;
  assign internal_vif.ALUSrcE = dut.internal_monitor.ALUSrcE;
  assign internal_vif.ALUControlE = dut.internal_monitor.ALUControlE;
  assign internal_vif.MemWriteE = dut.internal_monitor.MemWriteE;
  assign internal_vif.ResultSrcE = dut.internal_monitor.ResultSrcE;
  assign internal_vif.BranchE = dut.internal_monitor.BranchE;
  assign internal_vif.JumpE = dut.internal_monitor.JumpE;

  assign internal_vif.RegWriteM = dut.internal_monitor.RegWriteM;
  assign internal_vif.MemWriteM = dut.internal_monitor.MemWriteM;
  assign internal_vif.ResultSrcM = dut.internal_monitor.ResultSrcM;

  assign internal_vif.RegWriteW = dut.internal_monitor.RegWriteW;
  assign internal_vif.ResultSrcW = dut.internal_monitor.ResultSrcW;

  //--- hazard unit ---
  assign internal_vif.ForwardAE = dut.internal_monitor.ForwardAE;
  assign internal_vif.ForwardBE = dut.internal_monitor.ForwardBE;
  assign internal_vif.Forwarded_SrcB = dut.internal_monitor.Forwarded_SrcB;
  assign internal_vif.StallF = dut.internal_monitor.StallF;
  assign internal_vif.StallD = dut.internal_monitor.StallD;
  assign internal_vif.FlushD = dut.internal_monitor.FlushD;
  assign internal_vif.FlushE = dut.internal_monitor.FlushE;

  initial begin
    uvm_config_db#(virtual moka_rv32i_pipelined_if#(.DATA_WIDTH(DATA_WIDTH)))::set(null, "*", "vif", vif);
    uvm_config_db#(virtual moka_rv32i_pipelined_internal_if#(.DATA_WIDTH(DATA_WIDTH)))::set(null, "*", "internal_vif", internal_vif);
    run_test("moka_rv32i_pipelined_test");
  end

  initial begin
    #1000;  // Keep simulation alive for 1000ns
    $finish; // Then explicitly finish
  end

//  initial begin
//    $dumpfile("fifo_tb.vcd");
//    $dumpvars(0, fifo_tb);
//  end
  
endmodule
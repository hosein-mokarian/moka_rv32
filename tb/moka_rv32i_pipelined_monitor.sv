package moka_monitor_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_transaction_pkg::*;
import moka_internal_tx_pkg::*;

class moka_rv32i_pipelined_monitor extends uvm_monitor;
    virtual moka_rv32i_pipelined_if vif;
    virtual moka_rv32i_pipelined_internal_if internal_vif;
    uvm_analysis_port#(moka_rv32i_pipelined_transaction) ap;
    uvm_analysis_port#(moka_rv32i_pipelined_internal_tx) ap_internal;

    `uvm_component_utils(moka_rv32i_pipelined_monitor)

    function new (string name = "moka_rv32i_pipelined_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
        ap_internal = new("ap_internal", this);
    endfunction

    function void build_phase(uvm_phase phase);
        `uvm_info("MONITOR", "build phase entered", UVM_LOW)

        super.build_phase(phase);

        if (!uvm_config_db#(virtual moka_rv32i_pipelined_if#(.DATA_WIDTH(32)))::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set")
        end else begin
            `uvm_info("VIF", "Virtual interface set successfully", UVM_LOW)
        end

        if (!uvm_config_db#(virtual moka_rv32i_pipelined_internal_if#(.DATA_WIDTH(32)))::get(this, "", "internal_vif", internal_vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set")
        end else begin
            `uvm_info("VIF", "Virtual interface set successfully", UVM_LOW)
        end

        `uvm_info("MONITOR", "Build phase exited.", UVM_LOW)
    endfunction

    task run_phase(uvm_phase phase);
        moka_rv32i_pipelined_transaction tx;
        moka_rv32i_pipelined_internal_tx internal_tx;

        `uvm_info("MONITOR", "Run phase entered.", UVM_LOW)

        super.run_phase(phase);

        forever begin
            @(posedge vif.clk);

            `uvm_info("MONITOR", $sformatf("Received vif: rstn=%01b , en=%01b", vif.rstn, vif.en), UVM_MEDIUM)
            `uvm_info("MONITOR", $sformatf("Received vif: addr=0x%08h, data=0x%08h, we=%01b", vif.instr_mem_address, vif.instr_mem_write_data, vif.instr_mem_we), UVM_MEDIUM)

            tx = moka_rv32i_pipelined_transaction#(.DATA_WIDTH(32))::type_id::create("tx");

            tx.rstn = vif.rstn;
            tx.en = vif.en;
            tx.instr_mem_address = vif.instr_mem_address;
            tx.instr_mem_write_data = vif.instr_mem_write_data;
            tx.instr_mem_we = vif.instr_mem_we;

            ap.write(tx);

            internal_tx = moka_rv32i_pipelined_internal_tx#(.DATA_WIDTH(32))::type_id::create("internal_tx");

            //--- FETCH ---
            internal_tx.PCNext = internal_vif.PCNext;
            internal_tx.PCF = internal_vif.PCF;
            internal_tx.PCPlus4F = internal_vif.PCPlus4F;
            internal_tx.InstrF = internal_vif.InstrF;
            internal_tx.instr_mem_addr = internal_vif.instr_mem_addr;

            //--- DECODE ---
            internal_tx.InstrD = internal_vif.InstrD;
            internal_tx.PCD = internal_vif.PCD;
            internal_tx.PCPlus4D = internal_vif.PCPlus4D;

            internal_tx.op = internal_vif.op;
            internal_tx.funct3 = internal_vif.funct3;
            internal_tx.funct7 = internal_vif.funct7;
            internal_tx.Rs1D = internal_vif.Rs1D;
            internal_tx.Rs2D = internal_vif.Rs2D;
            internal_tx.RdD = internal_vif.RdD;
            internal_tx.Immidate = internal_vif.Immidate;
            internal_tx.ImmExtD = internal_vif.ImmExtD;
            internal_tx.RD1D = internal_vif.RD1D;
            internal_tx.RD2D = internal_vif.RD2D;

            //--- EXECUTE ---
            internal_tx.PCE = internal_vif.PCE;
            internal_tx.PCPlus4E = internal_vif.PCPlus4E;
            internal_tx.Rs1E = internal_vif.Rs1E;
            internal_tx.Rs2E = internal_vif.Rs2E;
            internal_tx.RdE = internal_vif.RdE;
            internal_tx.ImmExtE = internal_vif.ImmExtE;
            internal_tx.RD1E = internal_vif.RD1E;
            internal_tx.RD2E = internal_vif.RD2E;
            internal_tx.WritDataE = internal_vif.WritDataE;

            internal_tx.SrcAE = internal_vif.SrcAE;
            internal_tx.SrcBE = internal_vif.SrcBE;
            internal_tx.zeroE = internal_vif.zeroE;
            internal_tx.ALUResultE = internal_vif.ALUResultE;

            internal_tx.PCTargetE = internal_vif.PCTargetE;

            //--- MEMORY ---
            internal_tx.RdM = internal_vif.RdM;
            internal_tx.ALUResultM = internal_vif.ALUResultM;
            internal_tx.WritDataM = internal_vif.WritDataM;
            internal_tx.PCPlus4M = internal_vif.PCPlus4M;

            internal_tx.ReadDateM = internal_vif.ReadDateM;

            //--- WRITEBACK ---
            internal_tx.RdW = internal_vif.RdW;
            internal_tx.ALUResultW = internal_vif.ALUResultW;
            internal_tx.ReadDateW = internal_vif.ReadDateW;
            internal_tx.PCPlus4W = internal_vif.PCPlus4W;

            internal_tx.ResultW = internal_vif.ResultW;

            //--- control unit ---
            internal_tx.RegWriteD = internal_vif.RegWriteD;
            internal_tx.ImmSrcD = internal_vif.ImmSrcD;
            internal_tx.ALUSrcD = internal_vif.ALUSrcD;
            internal_tx.ALUControlD = internal_vif.ALUControlD;
            internal_tx.MemWriteD = internal_vif.MemWriteD;
            internal_tx.ResultSrcD = internal_vif.ResultSrcD;
            internal_tx.BranchD = internal_vif.BranchD;
            internal_tx.JumpD = internal_vif.JumpD;

            internal_tx.PCSrcE = internal_vif.PCSrcE;
            internal_tx.RegWriteE = internal_vif.RegWriteE;
            internal_tx.ALUSrcE = internal_vif.ALUSrcE;
            internal_tx.ALUControlE = internal_vif.ALUControlE;
            internal_tx.MemWriteE = internal_vif.MemWriteE;
            internal_tx.ResultSrcE = internal_vif.ResultSrcE;
            internal_tx.BranchE = internal_vif.BranchE;
            internal_tx.JumpE = internal_vif.JumpE;

            internal_tx.RegWriteM = internal_vif.RegWriteM;
            internal_tx.MemWriteM = internal_vif.MemWriteM;
            internal_tx.ResultSrcM = internal_vif.ResultSrcM;

            internal_tx.RegWriteW = internal_vif.RegWriteW;
            internal_tx.ResultSrcW = internal_vif.ResultSrcW;

            //--- hazard unit ---
            internal_tx.ForwardAE = internal_vif.ForwardAE;
            internal_tx.ForwardBE = internal_vif.ForwardBE;
            internal_tx.Forwarded_SrcB = internal_vif.Forwarded_SrcB;
            internal_tx.StallF = internal_vif.StallF;
            internal_tx.StallD = internal_vif.StallD;
            internal_tx.FlushD = internal_vif.FlushD;
            internal_tx.FlushE = internal_vif.FlushE;

            ap_internal.write(internal_tx);

            if (vif.en == 1 && vif.instr_mem_we == 0)
            begin

                //--- FETCH ---
                `uvm_info("MONITOR", $sformatf("PCNext=0x%08h", internal_vif.PCNext), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("PCF=0x%08h", internal_vif.PCF), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("PCPlus4F=0x%08h", internal_vif.PCPlus4F), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("InstrF=0x%08h", internal_vif.InstrF), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("instr_mem_addr=0x%08h", internal_vif.instr_mem_addr), UVM_LOW)

                //--- DECODE ---
                `uvm_info("MONITOR", $sformatf("InstrD=0x%08h", internal_vif.InstrD), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("PCD=0x%08h", internal_vif.PCD), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("PCPlus4D=0x%08h", internal_vif.PCPlus4D), UVM_LOW)

                `uvm_info("MONITOR", $sformatf("op=0x%08h", internal_vif.op), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("funct3=0x%08h", internal_vif.funct3), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("funct7=0x%08h", internal_vif.funct7), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("Rs1D=0x%08h", internal_vif.Rs1D), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("Rs2D=0x%08h", internal_vif.Rs2D), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("RdD=0x%08h", internal_vif.RdD), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("Immidate=0x%08h", internal_vif.Immidate), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("ImmExtD=0x%08h", internal_vif.ImmExtD), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("RD1D=0x%08h", internal_vif.RD1D), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("RD2D=0x%08h", internal_vif.RD2D), UVM_LOW)

                //--- EXECUTE ---
                `uvm_info("MONITOR", $sformatf("PCE=0x%08h", internal_vif.PCE), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("PCPlus4E=0x%08h", internal_vif.PCPlus4E), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("Rs1E=0x%08h", internal_vif.Rs1E), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("Rs2E=0x%08h", internal_vif.Rs2E), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("RdE=0x%08h", internal_vif.RdE), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("ImmExtE=0x%08h", internal_vif.ImmExtE), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("RD1E=0x%08h", internal_vif.RD1E), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("RD2E=0x%08h", internal_vif.RD2E), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("WritDataE=0x%08h", internal_vif.WritDataE), UVM_LOW)

                `uvm_info("MONITOR", $sformatf("SrcAE=0x%08h", internal_vif.SrcAE), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("SrcBE=0x%08h", internal_vif.SrcBE), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("zeroE=0x%08h", internal_vif.zeroE), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("ALUResultE=0x%08h", internal_vif.ALUResultE), UVM_LOW)

                `uvm_info("MONITOR", $sformatf("PCTargetE=0x%08h", internal_vif.PCTargetE), UVM_LOW)

                //--- MEMORY ---
                `uvm_info("MONITOR", $sformatf("RdM=0x%08h", internal_vif.RdM), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("ALUResultM=0x%08h", internal_vif.ALUResultM), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("WritDataM=0x%08h", internal_vif.WritDataM), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("PCPlus4M=0x%08h", internal_vif.PCPlus4M), UVM_LOW)

                `uvm_info("MONITOR", $sformatf("ReadDateM=0x%08h", internal_vif.ReadDateM), UVM_LOW)

                //--- WRITEBACK ---
                `uvm_info("MONITOR", $sformatf("RdW=0x%08h", internal_vif.RdW), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("ALUResultW=0x%08h", internal_vif.ALUResultW), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("ReadDateW=0x%08h", internal_vif.ReadDateW), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("PCPlus4W=0x%08h", internal_vif.PCPlus4W), UVM_LOW)

                `uvm_info("MONITOR", $sformatf("ResultW=0x%08h", internal_vif.ResultW), UVM_LOW)

                //--- control unit ---
                `uvm_info("MONITOR", $sformatf("RegWriteD=0x%08h", internal_vif.RegWriteD), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("ImmSrcD=0x%08h", internal_vif.ImmSrcD), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("ALUSrcD=0x%08h", internal_vif.ALUSrcD), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("ALUControlD=0x%08h", internal_vif.ALUControlD), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("MemWriteD=0x%08h", internal_vif.MemWriteD), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("ResultSrcD=0x%08h", internal_vif.ResultSrcD), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("BranchD=0x%08h", internal_vif.BranchD), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("JumpD=0x%08h", internal_vif.JumpD), UVM_LOW)

                `uvm_info("MONITOR", $sformatf("PCSrcE=0x%08h", internal_vif.PCSrcE), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("RegWriteE=0x%08h", internal_vif.RegWriteE), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("ALUSrcE=0x%08h", internal_vif.ALUSrcE), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("ALUControlE=0x%08h", internal_vif.ALUControlE), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("MemWriteE=0x%08h", internal_vif.MemWriteE), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("ResultSrcE=0x%08h", internal_vif.ResultSrcE), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("BranchE=0x%08h", internal_vif.BranchE), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("JumpE=0x%08h", internal_vif.JumpE), UVM_LOW)

                `uvm_info("MONITOR", $sformatf("RegWriteM=0x%08h", internal_vif.RegWriteM), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("MemWriteM=0x%08h", internal_vif.MemWriteM), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("ResultSrcM=0x%08h", internal_vif.ResultSrcM), UVM_LOW)

                `uvm_info("MONITOR", $sformatf("RegWriteW=0x%08h", internal_vif.RegWriteW), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("ResultSrcW=0x%08h", internal_vif.ResultSrcW), UVM_LOW)

                //--- hazard unit ---
                `uvm_info("MONITOR", $sformatf("ForwardAE=0x%08h", internal_vif.ForwardAE), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("ForwardBE=0x%08h", internal_vif.ForwardBE), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("Forwarded_SrcB=0x%08h", internal_vif.Forwarded_SrcB), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("StallF=0x%08h", internal_vif.StallF), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("StallD=0x%08h", internal_vif.StallD), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("FlushD=0x%08h", internal_vif.FlushD), UVM_LOW)
                `uvm_info("MONITOR", $sformatf("FlushE=0x%08h", internal_vif.FlushE), UVM_LOW)
            end
        end

        `uvm_info("MONITOR", "Run phase exited", UVM_LOW)

    endtask

endclass

endpackage
package moka_env_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_agent_pkg::*;
import moka_scoreboard_pkg::*;
import moka_coverage_pkg::*;

class moka_rv32i_pipelined_env extends uvm_env;
    moka_rv32i_pipelined_agent agent;
    moka_rv32i_pipelined_scoreboard scb;
    moka_rv32i_pipelined_coverage coverage;

    `uvm_component_utils(moka_rv32i_pipelined_env)

    function new(string name = "moka_rv32i_pipelined_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        `uvm_info("ENV", "Build phase entered.", UVM_LOW)

        super.build_phase(phase);

        agent = moka_rv32i_pipelined_agent::type_id::create("agent", this);
        scb = moka_rv32i_pipelined_scoreboard::type_id::create("scb", this);
        coverage = moka_rv32i_pipelined_coverage::type_id::create("coverage", this);

        `uvm_info("ENV", "Build phase exited.", UVM_LOW)
    endfunction

    function void connect_phase(uvm_phase phase);
        `uvm_info("ENV", "Run phase entered.", UVM_LOW)
        
        super.connect_phase(phase);        
        
        agent.monitor.ap.connect(scb.ap_imp);
        agent.monitor.ap.connect(coverage.analysis_export);

        `uvm_info("ENV", "Run phase exited.", UVM_LOW)
    endfunction
endclass

endpackage
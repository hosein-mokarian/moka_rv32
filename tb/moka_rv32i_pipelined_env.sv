package moka_env_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_agent_pkg::*;
import moka_scoreboard_pkg::*;

class moka_rv32i_pipelined_env extends uvm_env;
    moka_rv32i_pipelined_agent agent;
    moka_rv32i_pipelined_scoreboard scb;

    `uvm_object_utils(moka_rv32i_pipelined_env)

    function new(string name = "moka_rv32i_pipelined_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        agent = moka_rv32i_pipelined_agent::type_id::create("agent", this);
        scb = moka_rv32i_pipelined_scoreboard::type_id::create("scb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        agent.monitor.ap.connect(scb.ap_imp);
    endfunction
endclass

endpackage
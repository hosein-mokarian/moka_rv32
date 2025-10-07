package moka_test_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_env_pkg::*;
import moka_seq_pkg::*;

class moka_rv32i_pipelined_test extends uvm_test;
    virtual moka_rv32i_pipelined_if vif;
    moka_rv32i_pipelined_env env;

    `uvm_component_utils(moka_rv32i_pipelined_test)

    function new(string name = "moka_rv32i_pipelined_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        `uvm_info("TEST", "Build phase entered.", UVM_LOW)

        super.build_phase(phase);

        env = moka_rv32i_pipelined_env::type_id::create("env", this);

        if (!uvm_config_db#(virtual moka_rv32i_pipelined_if#(.DATA_WIDTH(32)))::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set!")
        end else begin
            `uvm_info("VIF", "Virtual interface set successfully", UVM_LOW)
        end

        `uvm_info("TEST", "Build phase exited.", UVM_LOW)
    endfunction

    task run_phase(uvm_phase phase);
        moka_rv32i_pipelined_sequence seq;

        `uvm_info("TEST", "Run phase entered.", UVM_LOW)

        super.run_phase(phase);

        phase.raise_objection(this);

        `uvm_info("TEST", "Apllying reset signal ...", UVM_LOW)
        vif.rstn = 1'b0;
        vif.en = 1'b0;
        vif.instr_mem_address = 32'h00000000;
        vif.instr_mem_write_data = 32'hFFFFFFFF;
        vif.instr_mem_we = 1'b0;
        #2 vif.rstn = 1'b1;
        @(posedge vif.clk);
        // vif.en = 1'b1;

        `uvm_info("TEST", "Start the seq ...", UVM_LOW)
        seq = moka_rv32i_pipelined_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);

        phase.drop_objection(this);

        `uvm_info("TEST", "Run phase exited.", UVM_LOW)

    endtask

endclass

endpackage
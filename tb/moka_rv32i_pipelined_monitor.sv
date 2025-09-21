package moka_monitor_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_transaction_pkg::*;

class moka_rv32i_pipelined_monitor extends uvm_monitor;
    virtual moka_rv32i_pipelined_if vif;
    uvm_analysis_port#(moka_rv32i_pipelined_transaction) ap;

    `uvm_object_utils(moka_rv32i_pipelined_monitor)

    function new (string name = "moka_rv32i_pipelined_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        `uvm_info("MONITOR", "build phase entered", UVM_LOW)
        super.build_phase(phase);
        if (!uvm_config_db#(virtual moka_rv32i_pipelined_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set")
        end else begin
            `uvm_info("VIF", "Virtual interface set successfully", UVM_LOW)
        end
    endfunction

    task run_phase(uvm_phase phase);
        moka_rv32i_pipelined_transaction tx;

        forever begin
            // @(posedge vif.clk);
            tx = moka_rv32i_pipelined_transaction::type_id::create("");
            // tx.en = vif.en;
            ap.write(tx);
        end

    endtask

endclass

endpackage
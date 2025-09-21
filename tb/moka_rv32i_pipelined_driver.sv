package moka_driver_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_transaction_pkg::*;

class moka_rv32i_pipelined_driver extends uvm_driver#(moka_rv32i_pipelined_transaction);
    virtual moka_rv32i_pipelined_if vif;

    `uvm_object_utils(moka_rv32i_pipelined_driver)

    function new (string name = "moka_rv32i_pipelined_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        `uvm_info("DRIVER", "build phase entered", UVM_LOW)
        super.build_phase(phase);
        if (!uvm_config_db#(virtual moka_rv32i_pipelined_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set!")
        end else begin
            `uvm_info("VIF", "Virtual interface set successfully", UVM_LOW)
        end
    endfunction

    task run_phass(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            
            vif.rstn = req.rstn;
            vif.en = req.en;

            seq_item_port.item_done();
        end
    endtask
endclass

endpackage
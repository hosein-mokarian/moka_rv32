package moka_driver_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_transaction_pkg::*;

class moka_rv32i_pipelined_driver extends uvm_driver#(moka_rv32i_pipelined_transaction);
    virtual moka_rv32i_pipelined_if vif;

    `uvm_component_utils(moka_rv32i_pipelined_driver)

    function new (string name = "moka_rv32i_pipelined_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        `uvm_info("DRIVER", "build phase entered", UVM_LOW)

        super.build_phase(phase);

        if (!uvm_config_db#(virtual moka_rv32i_pipelined_if#(.DATA_WIDTH(32)))::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "Virtual interface not set!")
        end else begin
            `uvm_info("VIF", "Virtual interface set successfully", UVM_LOW)
        end

        `uvm_info("DRIVER", "Build phase exited.", UVM_LOW)
    endfunction

    task run_phase(uvm_phase phase);

        `uvm_info("DRIVER", "Run phase entered.", UVM_LOW)

        super.run_phase(phase);

        forever begin

            seq_item_port.get_next_item(req);

            `uvm_info("DRIVER", $sformatf("Received seq: rstn=%01b , en=%01b", req.rstn, req.en), UVM_MEDIUM)
            `uvm_info("DRIVER", $sformatf("Received seq: addr=0x%08h, data=0x%08h, we=%01b", req.instr_mem_address, req.instr_mem_write_data, req.instr_mem_we), UVM_MEDIUM)

            `uvm_info("DRIVER", "waiting for the negedge clk ...", UVM_LOW)
            @(negedge vif.clk);
            `uvm_info("DRIVER", "Negedge clk is occurred.", UVM_LOW)

            vif.rstn = req.rstn;
            vif.en = req.en;
            vif.instr_mem_address = req.instr_mem_address;
            vif.instr_mem_write_data = req.instr_mem_write_data;
            vif.instr_mem_we = req.instr_mem_we;

            seq_item_port.item_done();
        end

        `uvm_info("DRIVER", "Run phase exited.", UVM_LOW)
    endtask
endclass

endpackage
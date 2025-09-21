package moka_scoreboard_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_transaction_pkg::*;

class moka_rv32i_pipelined_scoreboard extends uvm_scoreboard;
    uvm_analysis_imp #(moka_rv32i_pipelined_transaction, moka_rv32i_pipelined_scoreboard) ap_imp;

    `uvm_object_utils(moka_rv32i_pipelined_scoreboard)

    function new(string name = "moka_rv32i_pipelined_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        ap_imp = new("ap_imp", this);
    endfunction

    function void write(moka_rv32i_pipelined_transaction tx);
        // analysis
        // `uvm_info("SCB", $sformatf("Sampled %s: data=0x%0h", tx.wr_en ? "PUSH" : "POP", tx.din), UVM_LOW)
        // `uvm_info("SCB", $sformatf("Transaction contents: %s", tx.convert2string()), UVM_HIGH)
    endfunction

endclass

endpackage
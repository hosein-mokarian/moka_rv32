package moka_coverage_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_transaction_pkg::*;

class moka_rv32i_pipelined_coverage extends uvm_subscriber#(moka_rv32i_pipelined_transaction);
    `uvm_component_utils(moka_rv32i_pipelined_coverage)

    moka_rv32i_pipelined_transaction cov_trans;

    covergroup moka_rv32i_pipelined_cg;
        cp_rstn: coverpoint cov_trans.rstn {
            bins one = {1};
            bins zero = {1};
        }
    endgroup

    function new(string name = "moka_rv32i_pipelined_coverage", uvm_component parent = null);
        super.new(name, parent);
        moka_rv32i_pipelined_cg = new();
    endfunction

    function void write(moka_rv32i_pipelined_transaction t);
        cov_trans = t;
        moka_rv32i_pipelined_cg.sample();
        // `uvm_info("COV", $sformatf("Sampled %s: address=0x%0h, data=0x%0h", t.instr_mem_address, t.data), UVM_LOW)
    endfunction

endclass

endpackage
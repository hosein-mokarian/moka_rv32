package moka_transaction_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

class moka_rv32i_pipelined_transaction#(DATA_WIDTH = 32) extends uvm_sequence_item;
    logic rstn;
    logic en;
    logic [DATA_WIDTH - 1 : 0] instr_mem_address;
    logic [DATA_WIDTH - 1 : 0] instr_mem_write_data;
    logic instr_mem_we;

    `uvm_object_utils_begin(moka_rv32i_pipelined_transaction)
        `uvm_field_int(rstn, UVM_ALL_ON)
        `uvm_field_int(en, UVM_ALL_ON)
        `uvm_field_int(instr_mem_address, UVM_ALL_ON)
        `uvm_field_int(instr_mem_write_data, UVM_ALL_ON)
        `uvm_field_int(instr_mem_we, UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "moka_rv32i_pipelined_transaction");
        super.new(name);
    endfunction

endclass
    
endpackage
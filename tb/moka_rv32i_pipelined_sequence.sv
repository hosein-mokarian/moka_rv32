package moka_seq_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_transaction_pkg::*;

class moka_rv32i_pipelined_sequence extends uvm_sequence;
    rand int num_trans = 20;

    constraint num_trans_c {
        num_trans inside {[10:30]};
    }

    `uvm_object_utils(moka_rv32i_pipelined_sequence)

    task body;
        moka_rv32i_pipelined_transaction tx;

        repeat(num_trans) begin
            tx = moka_rv32i_pipelined_transaction::type_id::create("tx");
            start_item(tx);
            assert(tx.randomize());
            finish_item(tx);
        end
    endtask

endclass

endpackage
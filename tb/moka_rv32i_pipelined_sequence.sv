package moka_seq_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import moka_transaction_pkg::*;

class moka_rv32i_pipelined_sequence extends uvm_sequence#(moka_rv32i_pipelined_transaction);
    rand int num_trans = 20;

    constraint num_trans_c {
        num_trans inside {[10:30]};
    }

    `uvm_object_utils(moka_rv32i_pipelined_sequence)

    task body;
        int unsigned address;
        int unsigned data;

        repeat(1) begin // num_trans
            `uvm_info("SEQ", $sformatf("num_trans=%d", num_trans), UVM_LOW)

            `uvm_info("SEQ", "Instruction memory programming is started ...", UVM_LOW)

            // Test simple NOP instruction
            program_instr_memory(32'h00000000, 32'h00000013);

            // Simple Test program
            // program_instr_memory(32'h00000000, 32'h00600293);
            // program_instr_memory(32'h00000004, 32'h000024B7);
            // program_instr_memory(32'h00000008, 32'h00448493);
            // program_instr_memory(32'h0000000C, 32'h00002537);
            // program_instr_memory(32'h00000010, 32'h01000593);
            // program_instr_memory(32'h00000014, 32'h00B52023);
            // program_instr_memory(32'h00000018, 32'h00000513);
            // program_instr_memory(32'h0000001C, 32'hFFC4A303);
            // program_instr_memory(32'h00000020, 32'h0064A423);
            // program_instr_memory(32'h00000024, 32'h0062E233);
            // program_instr_memory(32'h00000028, 32'hFE420AE3);
            `uvm_info("SEQ", "Instruction memory programming is finished.", UVM_LOW)

            `uvm_info("SEQ", "Executing program ...", UVM_LOW)
            execute_program();
            #1000;
            `uvm_info("SEQ", "Program is run.", UVM_LOW)
        end
    endtask

    task program_instr_memory(int unsigned address, int unsigned data);
        logic rstn = 1'b1;
        logic en = 1'b0;
        logic we = 1'b1;

        // `uvm_info("SEQ", "program_instr_memory", UVM_LOW)

        // `uvm_info("SEQ", $sformatf("rstn=%1b", rstn), UVM_LOW)
        // `uvm_info("SEQ", $sformatf("en=%1b", en), UVM_LOW)
        // `uvm_info("SEQ", $sformatf("address=0x%08h", address), UVM_LOW)
        // `uvm_info("SEQ", $sformatf("data=0x%08h", data), UVM_LOW)
        // `uvm_info("SEQ", $sformatf("we=%1b", we), UVM_LOW)

        send_sequence(rstn, en, address, data, we);
    endtask

    task execute_program();
        logic rstn = 1'b1;
        logic en = 1'b1;
        int unsigned address = 32'bx;
        int unsigned data = 32'bx;
        logic we = 1'b0;

        send_sequence(rstn, en, address, data, we);
    endtask

    task send_sequence(logic rstn, logic en, int unsigned address, int unsigned data, logic we);
        moka_rv32i_pipelined_transaction tx;
        tx = moka_rv32i_pipelined_transaction#(.DATA_WIDTH(32))::type_id::create("tx");

        `uvm_info("SEQ", "send_sequence", UVM_LOW)

        `uvm_info("SEQ", $sformatf("rstn=%1b", rstn), UVM_LOW)
        `uvm_info("SEQ", $sformatf("en=%1b", en), UVM_LOW)
        `uvm_info("SEQ", $sformatf("address=0x%08h", address), UVM_LOW)
        `uvm_info("SEQ", $sformatf("data=0x%08h", data), UVM_LOW)
        `uvm_info("SEQ", $sformatf("we=%1b", we), UVM_LOW)

        tx.rstn = rstn;
        tx.en = en;
        tx.instr_mem_address = address;
        tx.instr_mem_write_data = data;
        tx.instr_mem_we = we;

        start_item(tx);
        // assert(tx.randomize());
        finish_item(tx);

    endtask

endclass

endpackage
interface moka_rv32i_pipelined_if#(DATA_WIDTH = 32)(input clk);
 logic rstn;
 logic en;
 logic [DATA_WIDTH - 1 : 0] instr_mem_address;
 logic [DATA_WIDTH - 1 : 0] instr_mem_write_data;
 logic instr_mem_we;
endinterface
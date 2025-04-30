run_simulation:
	clear
	iverilog -o pipelined_tb.vvp stimulus.v moka.v
	vvp pipelined_tb.vvp
	gtkwave pipelined_results.vcd
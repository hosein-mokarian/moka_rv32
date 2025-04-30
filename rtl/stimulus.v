`timescale 1ns/1ps

module stimulus;

  parameter DATA_WIDTH = 16;

  // Inputs
	reg clk;
	reg rstn;
	reg en;

	// Instantiate the Unit Under Test (UUT)
	moka_top uut (
		.clk(clk),
		.rstn(rstn),
		.en(en)
	);


  integer i = 1;
  integer fid_input_file, fid_output_file;


  initial
  begin

    // fid_input_file  = $fopen("ecg.txt", "r");
    // fid_output_file = $fopen("output.dat", "w");
    
    // if (fid_input_file == 0) 
    // begin
    //   $display("Error: Failed to open file \n Exiting Simulation.");
    //   $finish;
    // end

    clk = 0;
    rstn = 0;
    en = 0;

    #5 rstn = 1;
    #5 en = 1;

    // while (i > 0)
    // begin
    //   @(negedge clk) 
    //   begin
    //     i = $fscanf(fid_input_file, "%d", xin);
    //   end
    // end

    // $fclose(fid_input_file);
    #1000;
    $display("Simulation ended normally");
    $finish;

  end


  initial 
  begin
    $dumpfile("pipelined_results.vcd");
    $dumpvars(0, stimulus);
  end


  always
		#1 clk = ~clk; 

endmodule
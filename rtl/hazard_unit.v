module hazard_unit
  #(parameter DATA_WIDTH = 32)
  (
    input rstn,
    input en,
    input [4 : 0] Rs1D,
    input [4 : 0] Rs2D,
    input [4 : 0] Rs1E,
    input [4 : 0] Rs2E,
    input [4 : 0] RdE,
    input [4 : 0] RdM,
    input [4 : 0] RdW,
    input RegWriteM,
    input RegWriteW,
    input ResultSrcE0,
    input PCSrcE,
    output reg [1 : 0] ForwardAE,
    output reg [1 : 0] ForwardBE,
    output reg StallF,
    output reg StallD,
    output reg FlushD,
    output reg FlushE
  );


  reg lwStall;

  
  always @(*)
  begin
    if (!rstn)
    begin
      ForwardAE = 2'b0;
      ForwardBE = 2'b0;
      StallD = 1;
      StallF = 1;
      FlushE = 0;
    end
    else if (rstn && en)
    begin
      if ((Rs1E == RdM && RegWriteM) && (Rs1E != 0))
        ForwardAE = 2'b10;
      if ((Rs1E == RdW && RegWriteW) && (Rs1E != 0))
        ForwardAE = 2'b10;
      else
        ForwardAE = 2'b00;
      

      if ((Rs2E == RdM && RegWriteM) && (Rs2E != 0))
        ForwardBE = 2'b10;
      if ((Rs2E == RdW && RegWriteW) && (Rs2E != 0))
        ForwardBE = 2'b10;
      else
        ForwardBE = 2'b00;

      lwStall = ResultSrcE0 & ((Rs1D == RdE) | (Rs2D == RdE));
      StallF = lwStall;
      StallD = lwStall; 
      FlushD = PCSrcE;
      FlushE = lwStall | PCSrcE;
    end
  end


endmodule
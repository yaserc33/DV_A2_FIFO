`include "if.sv"
`include "fifo.sv"
`include "tran.sv"
`include "gen.sv"
`include "drv.sv"
`include "mon.sv"
`include "sco.sv"
`include "env.sv"
module top;
    
parameter DEPTH=8;    
parameter DATA_WIDTH=8;



fifo_if fif();

synchronous_fifo  #(DEPTH , DATA_WIDTH) DUT (
  .clk(fif.clk),
  .rst_n(fif.rst_n),
  .w_en(fif.w_en),
  .r_en(fif.r_en),
  .data_in(fif.data_in),
  .data_out(fif.data_out),
  .full(fif.full),
  .empty(fif.empty)
);


initial fif.clk <=0;
always #10 fif.clk <= ~fif.clk;


environment env ; 



initial begin
     
  

    env = new( fif, .mode(1));
    env.run();
end




endmodule
`include "if.sv"
`include "fifo.sv"
`include "tran.sv"
`include "gen.sv"
`include "drv.sv"
`include "mon.sv"
`include "sco.sv"
`include "env.sv"
module top ;
    
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


environment env ,env1; 



initial begin
     
  

    env = new( fif, .mode(1),.count(10));
    env.run();

  


     env = new( fif, .mode(2),.count(DEPTH));
     env.run();


    // [write when fifo is full] test
    env = new( fif, .mode(3),.count(17)); // count = depeth (write) + 1(Write) + depth (read)
    env.run();


    //read when fifo is full] test
    env = new( fif, .mode(4),.count(DEPTH+1));
    env.run();

     //read -write same time test
    env = new( fif, .mode(5),.count(10)); 
    env.run();

  
    


   
    $finish;
end

initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
end





endmodule
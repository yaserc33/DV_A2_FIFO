interface fifo_if #(parameter DEPTH=8, DATA_WIDTH=8)  ;
  
  logic clk, rst_n, w_en, r_en ; 
  logic [DATA_WIDTH-1:0] data_in;
  logic [DATA_WIDTH-1:0] data_out;
  logic full, empty;  
    




    task  reset;
    fif.rst_n <= 0 ; 
     @(negedge fif.clk);
    fif.rst_n <= 1;
     @(negedge fif.clk);
    $display("[drv] reset done.., at %0t" ,$time );
    endtask 




    task  write(bit [DATA_WIDTH-1:0] data);
     @(negedge fif.clk);
    fif.w_en <= 1 ;
     
    fif.r_en <= 0;

    fif.data_in <= data;
  
    //$display("[drv] data sent to FIFO = %0d  at %0t" , data , $time);
   
    endtask 




    task  read;
    @(negedge fif.clk);
    fif.w_en <= 0 ;
    fif.r_en <= 1;
    //$display("[drv] read  requset sent to FIFO ,at %0t" ,$time );
 

    endtask 


endinterface //fifo_if

interface fifo_if #(parameter DEPTH=8, DATA_WIDTH=8)  ;
  
  logic clk, rst_n, w_en, r_en ; 
  logic [DATA_WIDTH-1:0] data_in;
  logic [DATA_WIDTH-1:0] data_out;
  logic full, empty;  
    




    task  reset;
    fif.rst_n <= 0 ; 
     @(posedge fif.clk);
    fif.rst_n <= 1;
     @(posedge fif.clk);
    $display("[drv] reset done..  "  );
    endtask 




    task  write(bit [DATA_WIDTH-1:0] data);
    fif.w_en <= 1 ;
     
    fif.r_en <= 0;
    
    fif.data_in <= data;
  
    @(posedge fif.clk);
  
    $display("[drv] data sent to FIFO = %0d" , data);
    fif.w_en <=0; 
    endtask 




    task  read;
    fif.w_en <= 0 ;
    fif.r_en <= 1;
    $display("[drv] read  requset sent to FIFO" );
    @(posedge fif.clk);
    fif.r_en <=0; 
    endtask 


endinterface //fifo_if

interface fifo_if #(parameter DEPTH=8, DATA_WIDTH=8)  
  
  logic clk, rst_n, w_en, r_en ; 
  logic [DATA_WIDTH-1:0] data_in;
  logic [DATA_WIDTH-1:0] data_out;
  logic full, empty;  
    
endinterface //fifo_if

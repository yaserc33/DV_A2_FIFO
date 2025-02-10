class transaction;
  bit  w_en, r_en;  
  rand bit [DATA_WIDTH-1:0] data_in;
  bit [DATA_WIDTH-1:0] data_out;
  bit full, empty;  
  bit rst_n;
    
    
    
    function transaction copy();
    
     
    endfunction //new()




endclass //transaction
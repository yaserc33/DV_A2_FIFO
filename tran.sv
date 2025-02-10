class transaction ;
  rand bit  w_en;
  rand bit  r_en;  
  rand bit [7:0] data_in;
  bit [7:0] data_out;
  bit full;
  bit empty;  

    
  constraint R_or_W { w_en != r_en;}

  constraint write_weight { w_en dist {1:=75 , 0:=25 }; }




    
    function transaction copy();
     
     copy = new();

     copy.w_en = this.w_en;
     copy.r_en = this.r_en;
     copy.data_in = this.data_in;
     copy.data_out = this.data_out;
     copy.full = this.full;
     copy.empty= this.empty; 
     
    endfunction //new()




endclass //transaction
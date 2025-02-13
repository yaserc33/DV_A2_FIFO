class driver;

virtual fifo_if fif;
mailbox #(transaction) gen2drv;
transaction tx;



    function new(mailbox #(transaction) a);
    gen2drv = a;

    endfunction //new()

    task  reset;
    fif.rst_n <= 0 ; 
    @(posedge fif.clk);
    fif.rst_n <= 1;
    $display("[drv] reset done.., at %0t" ,$time );
    endtask 




    task  write();
     @(negedge fif.clk);
    fif.w_en <= 1 ;
     
    fif.r_en <= 0;

    fif.data_in <= tx.data_in;
  
    //$display("[drv] data sent to FIFO = %0d  at %0t" , data , $time);
   
    endtask 

    task read_write();
     @(negedge fif.clk);
    fif.w_en <= 1 ;
     
    fif.r_en <= 1;

    fif.data_in <= tx.data_in;

    endtask


    task  read;
    @(negedge fif.clk);
    fif.w_en <= 0 ;
    fif.r_en <= 1;
    //$display("[drv] read  requset sent to FIFO ,at %0t" ,$time );
 

    endtask 

    task run();
    
        tx = new();
        forever begin
        
            gen2drv.get(tx);


            if(tx.r_en&&tx.w_en)
                read_write();
            else if (tx.r_en)
                read();    
            
            else if (tx.w_en)  
                write();  
           
        //$display("[drv_debugg] : reset:%0d Wr:%0d rd:%0d din:%0d dout:%0d full:%0d empty:%0d at %t",fif.rst_n, tx.w_en, tx.r_en, tx.data_in, tx.data_out, tx.full, tx.empty , $time); 
     
        
        
       
        end


    endtask



endclass //driver
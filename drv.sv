class driver;

virtual fifo_if fif;
mailbox #(transaction) gen2drv;
transaction tx;


    function new(mailbox #(transaction) a);
    gen2drv = a;

    endfunction //new()



    task run();
    
        tx = new();
        forever begin
            gen2drv.get(tx);
        
            if (tx.r_en)
                fif.read();    
            
            else if (tx.w_en)  
                fif.write(tx.data_in);  
               
        $display("[drv_debugg] : reset:%0d Wr:%0d rd:%0d din:%0d dout:%0d full:%0d empty:%0d",fif.rst_n, tx.w_en, tx.r_en, tx.data_in, tx.data_out, tx.full, tx.empty); 
         @(posedge fif.clk);
        

       
        end


    endtask



endclass //driver
class generator;
    

    transaction tx;
    mailbox #(transaction) gen2drv;

    int count; //to controll the number  of stimulus gen will generate 
    int mode ;





    function new(  mailbox #(transaction) a,int count );
    gen2drv  = a ;
    this.count = count;
    endfunction //new()




    task run(int mode);
   
   case (mode)
    1: //first test v_items
    begin 
        tx = new();
        repeat(count) begin
        assert (tx.randomize) else  $error("randomiztion faild at time = %t s" , $time);
        gen2drv.put(tx.copy);
        //$display("[GeN] : data sent to drv & sco = %0d" , tx.data_in );
        $display("[GEN_debugg] : Wr:%d rd:%d din:%d dout:%d full:%d empty:%d at %0t", tx.w_en, tx.r_en, tx.data_in, tx.data_out, tx.full, tx.empty , $time);
        end
       
      
    end
    2: //second test
    begin


    end

   endcase

endtask



endclass //generator
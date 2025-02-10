class generator;
    

    transaction tx;
    mailbox gen2soc;
    mailbox gen2drv;

    event next;  // to make genrate wait until the transaction is proccesd
    event done; // generator finshed genrate all the casses 

    int mode ;





    function new(mailbox a , mailbox b);
    gen2drv  = a ;
    gen2soc = b;
    tx = new()

    endfunction //new()




    task run(int mode);
   
   case (mode)
    1: 
        tx = new();
        repeat(5) begin
        assert (tx.randomize) else  $error("randomiztion faild at time = %t s" , $time);
        tx.put(gen2drv);
        tx.put(gen2soc);
        $display("[GeN] : data sent to drv & sco = %0d" , tx.data_in );
        wite(next.triggred);
        end
        ->done;

   endcase

endtask




endclass //generator
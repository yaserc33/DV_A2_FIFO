class generator;
    

    transaction tx;
    mailbox #(transaction) gen2soc;
    mailbox #(transaction) gen2drv;

    event next;  // to make genrate wait until the transaction is proccesd
    event done; // generator finshed genrate all the casses 

    int mode ;





    function new(mailbox #(transaction) a , mailbox #(transaction) b);
    gen2drv  = a ;
    gen2soc = b;
    tx = new();

    endfunction //new()




    task run(int mode);
   
   case (mode)
    1: //first test v_items
    begin 
        tx = new();
        repeat(10) begin
        assert (tx.randomize) else  $error("randomiztion faild at time = %t s" , $time);
        gen2drv.put(tx.copy);
        gen2soc.put(tx.copy);
        //$display("[GeN] : data sent to drv & sco = %0d" , tx.data_in );
        $display("[GEN_debugg] : Wr:%0d rd:%0d din:%0d dout:%0d full:%0d empty:%0d", tx.w_en, tx.r_en, tx.data_in, tx.data_out, tx.full, tx.empty);
        wait(next.triggered);
        end
        ->done;
    end
    2: //second test
    begin


    end

   endcase

endtask



endclass //generator
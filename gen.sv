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
        $display("\n\n\n~~~~~~~~~~~~~~~~~~~~~~~[v_item] test~~~~~~~~~~~~~~~~~~~~~~\n\n\n");
        $display("list of generated transactions :  ");
        if (count%2 == 0) begin
            repeat(count/2) begin
            assert (tx.randomize with { w_en ==1 ;} ) else  $error("randomiztion faild at time = %t s" , $time);
            gen2drv.put(tx.copy);
            //$display("[gen -debugging] :  Wr:%0d rd:%0d din:%0d dout:%0d full:%0d empty:%0d", tx.w_en, tx.r_en, tx.data_in, tx.data_out, tx.full, tx.empty);

            $display("[GEN🧬] : Wr:%d rd:%d din:%d ", tx.w_en, tx.r_en, tx.data_in);
            end

            repeat(count/2) begin
            assert (tx.randomize with { r_en ==1 ;} ) else  $error("randomiztion faild at time = %t s" , $time);
            gen2drv.put(tx.copy);
            //$display("[gen -debugging] :  Wr:%0d rd:%0d din:%0d dout:%0d full:%0d empty:%0d", tx.w_en, tx.r_en, tx.data_in, tx.data_out, tx.full, tx.empty);

            $display("[GEN🧬] : rd:%d",  tx.r_en);
            end
        end else $display("count should be even number... \n finishing [v_item] test");
    end
    2: 
      begin 
        tx = new();
        $display("\n\n\n~~~~~~~~~~~~~~~~~~~~~~~[fill FIFO] test~~~~~~~~~~~~~~~~~~~~~~\n\n\n");
        $display("list of generated transactions :  ");
       
            repeat(count) begin
            assert (tx.randomize with { w_en ==1 ;} ) else  $error("randomiztion faild at time = %t s" , $time);
            gen2drv.put(tx.copy);
            //$display("[GeN] : data sent to drv & sco = %0d" , tx.data_in );
            $display("[GEN🧬] : Wr:%d rd:%d din:%d ", tx.w_en, tx.r_en, tx.data_in);
            end
      end

    3:

      begin 
        tx = new();
        $display("\n\n\n~~~~~~~~~~~~~~~~~~~~~~~[write when fifo is full] test~~~~~~~~~~~~~~~~~~~~~~\n\n\n");
        $display("list of generated transactions :  ");
       
            repeat(count-8) begin
            assert (tx.randomize with { w_en ==1 ;} ) else  $error("randomiztion faild at time = %t s" , $time);
            gen2drv.put(tx.copy);
            //$display("[GeN] : data sent to drv & sco = %0d" , tx.data_in );
            $display("[GEN🧬] : Wr:%d rd:%d din:%d ", tx.w_en, tx.r_en, tx.data_in);
            end

             repeat(count-9) begin
            assert (tx.randomize with { r_en ==1 ;} ) else  $error("randomiztion faild at time = %t s" , $time);
            gen2drv.put(tx.copy);
            //$display("[GeN] : data sent to drv & sco = %0d" , tx.data_in );
            $display("[GEN🧬] :  rd:%d  ", tx.r_en);
            end
      end


   4:

      begin 
        tx = new();
        $display("\n\n\n~~~~~~~~~~~~~~~~~~~~~~~[read when fifo is full] test~~~~~~~~~~~~~~~~~~~~~~\n\n\n");
        $display("list of generated transactions :  ");
       
            repeat(count-1) begin
            assert (tx.randomize with { w_en ==1 ;} ) else  $error("randomiztion faild at time = %t s" , $time);
            gen2drv.put(tx.copy);
            //$display("[GeN] : data sent to drv & sco = %0d" , tx.data_in );
            $display("[GEN🧬] : Wr:%d rd:%d din:%d ", tx.w_en, tx.r_en, tx.data_in);
            end

             repeat(1) begin
            assert (tx.randomize with { r_en ==1 ;} ) else  $error("randomiztion faild at time = %t s" , $time);
            gen2drv.put(tx.copy);
            //$display("[GeN] : data sent to drv & sco = %0d" , tx.data_in );
            $display("[GEN🧬] :  rd:%d  ", tx.r_en);
            end
      end



       5: //first test v_items
    begin 
        tx = new();
        $display("\n\n\n~~~~~~~~~~~~~~~~~~~~~~~[read- write in same time] test~~~~~~~~~~~~~~~~~~~~~~\n\n\n");
        $display("list of generated transactions :  ");
        if (count%2 == 0) begin
            repeat(count/2) begin
            assert (tx.randomize with { w_en ==1 ;} ) else  $error("randomiztion faild at time = %t s" , $time);
            gen2drv.put(tx.copy);
            //$display("[gen -debugging] :  Wr:%0d rd:%0d din:%0d dout:%0d full:%0d empty:%0d", tx.w_en, tx.r_en, tx.data_in, tx.data_out, tx.full, tx.empty);

            $display("[GEN🧬] : Wr:%d rd:%d din:%d ", tx.w_en, tx.r_en, tx.data_in);
            end




            tx.R_or_W.constraint_mode(0); 
            repeat(count/2) begin
            assert (tx.randomize with { r_en ==1 ; w_en ==1 ;} ) else  $error("randomiztion faild at time = %t s" , $time);
            gen2drv.put(tx.copy);
            //$display("[gen -debugging] :  Wr:%0d rd:%0d din:%0d dout:%0d full:%0d empty:%0d", tx.w_en, tx.r_en, tx.data_in, tx.data_out, tx.full, tx.empty);

                 $display("[GEN🧬] : Wr:%d rd:%d din:%d ", tx.w_en, tx.r_en, tx.data_in);
            end
        end else $display("count should be even number... \n finishing [v_item] test");
    end
   

   endcase

endtask



endclass //generator
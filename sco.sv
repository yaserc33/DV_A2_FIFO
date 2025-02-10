class scoreboard;
    
    mailbox gen2soc;
    mailbox mon2sco;
    transaction rx;

    event next;
    bit [7:0] data_gen [$];
    bit [7:0] data_mon [$];


      typedef struct {
        bit [7:0] data;
        bit valid; // to destenguish the values of transaction ( valid =1) from values I will add to allign both of queues (valied == 0)   
    } data_packet_t;

    data_packet_t data_gen [$];
    data_packet_t data_mon [$];


    function new(mailbox a ,mailbox b);
    gen2sco =a;
    mon2sco =b;
    endfunction //new()



    task  run();
     rx = new();
     forever  begin
        gen2drv.get(rx); //first store the value connming from generator
        
        if (rx.w_en)  data_gen.push_front('{data: rx.data_in , valid: 1});  // to record the genrated value
        $display("[SCO]:  %0d recived from [GEN] at %t " ,rx.data_in ,$time  );



       mon2sco.get(rx);
       //$display("[SCO -debugging] : reset:%0d Wr:%0d rd:%0d din:%0d dout:%0d full:%0d empty:%0d",rx.rst_n, rx.w_en, rx.r_en, rx.data_in, rx.data_out, rx.full, rx.empty);

        if (rx.r_en)   data_mon.push_front('{data: rx.data_in , valid: 1});  // to record the  value coming from dut   
        $display("[SCO]:  %0d recived from [MON]  at %t " ,rx.data_in ,$time );       

        

        ->next;
     end 



     function void result;
      
     $display("-----------------------test result-------------------------");
   
  
        int gen_size = data_gen.size();
        int mon_size = data_mon.size();
        int max_size = (gen_size > mon_size) ? gen_size : mon_size;
        int mismatch_count = 0;

        // Extend the shorter queue with valid = 0  flag
         while (data_gen.size() < max_size) data_gen.push_back('{data: 8'h00, valid: 0});
         while (data_mon.size() < max_size) data_mon.push_back('{data: 8'h00, valid: 0});

        $display("data_gen   valid   data_mon   valid   match?");
        $display("------------------------------------------");

        // Compare elements
        for (int i = 0; i < max_size; i++) begin
            string match_status;

            if (!data_gen[i].valid || !data_mon[i].valid) begin
                match_status = "-"; // Ignore padding values
            end else if (data_gen[i].data == data_mon[i].data) begin
                match_status = "yes";
            end else begin
                match_status = "no";
                mismatch_count++;
            end

            $display("%0d\t  %0b\t   %0d\t  %0b\t   %s", 
                     data_gen[i].data, data_gen[i].valid, 
                     data_mon[i].data, data_mon[i].valid, 
                     match_status);
        end


        if (mismatch_count)begin
        $display("---------------- test failed--------------------------");
        $display("Total mismatches (excluding invalids): %0d", mismatch_count);
        end else
        $display("---------------- test passed!!--------------------------");
    endfunction



        





    endtask 












endclass //scoreboard
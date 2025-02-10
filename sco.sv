class scoreboard;

  mailbox #(transaction) gen2sco;
  mailbox #(transaction) mon2sco;
  transaction rx;

  event next;



  typedef struct {
    bit [7:0] data;
    bit valid; // to destenguish the values of transaction ( valid =1) from values I will add to allign both of queues (valied == 0)   
  } data_packet_t;

  data_packet_t data_gen[$];
  data_packet_t data_mon[$];


  function new(mailbox#(transaction) a, mailbox#(transaction) b);
    gen2sco = a;
    mon2sco = b;
  endfunction  //new()



  task run();
    rx = new();
    forever begin
      gen2sco.get(rx);  //first store the value connming from generator

      if (rx.w_en) begin
        data_gen.push_front('{data: rx.data_in, valid: 1});  // to record the genrated value
        $display("[SCO]:  %0d recived from [GEN] at %0t ", rx.data_in, $time);
      end



      mon2sco.get(rx);  // second store the value comming from dut
      //$display("[SCO -debugging] : reset:%0d Wr:%0d rd:%0d din:%0d dout:%0d full:%0d empty:%0d",rx.rst_n, rx.w_en, rx.r_en, rx.data_in, rx.data_out, rx.full, rx.empty);

      if (rx.r_en) begin
        data_mon.push_front('{data: rx.data_out, valid: 1
                            });  // to record the  value coming from dut   
        $display("[SCO]:  %0d recived from [MON]  at %0t ", rx.data_out, $time);
      end



      ->next;
    end

  endtask





// Compare queue
  int gen_size;
  int mon_size;
  int max_size;
  int mismatch_count;
  string match_status;



  





  
  task result;
      $display("\n\n\n-------------------Test Result--------------------------");

     gen_size = data_gen.size();
     mon_size = data_mon.size();
     max_size = (gen_size > mon_size) ? gen_size : mon_size;
     mismatch_count = 0;

    // Extend the shorter queue with {valid = 0} padding
    while (data_gen.size() < max_size) data_gen.push_back('{data: 8'h00, valid: 0});
    while (data_mon.size() < max_size) data_mon.push_back('{data: 8'h00, valid: 0});

    // Debug: Print sizes
         $display("\n--------------------size of queues----------------------");
    $display( "data_gen size = %0d, data_mon size = %0d", data_gen.size(), data_mon.size());
   

    // Print header
     $display("\n--------------------comparing table----------------");
    $display("queue(gen)   valid   FIFO(dut)   valid   match?");
    $display("------------------------------------------------------");



    // Compare elements
    for (int i = 0; i < max_size; i++) begin

      // Ensure valid index access
      if (i >= data_gen.size() || i >= data_mon.size()) begin
        $error("Index out of bounds: i = %0d", i);
        break;
      end

      // Assign value inside the loop
      if (!data_gen[i].valid || !data_mon[i].valid) begin
        match_status = "-";  // Ignore padding values
      end else if (data_gen[i].data == data_mon[i].data) begin
        match_status = "yes";
      end else begin
        match_status = "no";
        mismatch_count++;
      end

      $display("%d\t\t%b\t%d\t   %b\t   %s", data_gen[i].data, data_gen[i].valid,
               data_mon[i].data, data_mon[i].valid, match_status);
    end

    // Print result
    if (mismatch_count) begin
      $display("---------------- Test Failed --------------------------");
      $display("Total mismatches (excluding invalids): %0d", mismatch_count);
    end else begin
      $display("---------------- Test Passed!! --------------------------");
    end
  endtask


endclass

class scoreboard;

  mailbox #(transaction) mon2sco;
  transaction rx;


  event done; // to end simulation

  int gen_count =0;
  int count =0;



  typedef struct {
    bit [7:0] data;
    bit valid; // to destenguish the values of transaction ( valid =1) from values I will add to allign both of queues (valied == 0)   
  } data_packet_t;

  data_packet_t data_gen[$];
  data_packet_t data_dut[$];


  function new(mailbox#(transaction) b, int count);
    mon2sco = b;

    this.count = count;
  endfunction  //new()



  task run();
    rx = new();
    forever begin
      mon2sco.get(rx);  // second store the value comming from dut
      
      if (rx.w_en) begin
        data_gen.push_front('{data: rx.data_in, valid: 1});  // to record the genrated value
        //$display("[SCO]:  %0d recived from [GEN] at %0t s", rx.data_in, $time);
        //$display("[SOC]: gen queue : %p" ,data_gen ); 
        gen_count++;
      end
      else if (rx.r_en) begin
        data_dut.push_front('{data: rx.data_out, valid: 1});  // to record the  value coming from dut   
        //$display("[SCO]:  %0d recived from [DUT]  at %0t s", rx.data_out, $time);
        //$display("[SOC]: dut queue : %p" ,data_gen ); 
        gen_count++;
      end

      //$display("[SCO -debugging] :  Wr:%0d rd:%0d din:%0d dout:%0d full:%0d empty:%0d", rx.w_en, rx.r_en, rx.data_in, rx.data_out, rx.full, rx.empty);
      
     

     if (count == gen_count)begin
            ->done;
            $display("[SCO]: done ");
     end

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
     mon_size = data_dut.size();
     max_size = (gen_size > mon_size) ? gen_size : mon_size;
     mismatch_count = 0;
    // // Debug: Print sizes
    //      $display("\n--------------------size of queues----------------------");
    // $display( "data_gen size = %0d, data_dut size = %0d", data_gen.size(), data_dut.size());




    // Extend the shorter queue with {valid = 0} padding
    while (data_gen.size() < max_size) data_gen.push_front('{data: 8'h00, valid: 0});
    while (data_dut.size() < max_size) data_dut.push_front('{data: 8'h00, valid: 0});

   

    // Print header
     $display("\n--------------------comparing table----------------");
    $display("queue(gen)   valid   FIFO(dut)   valid   match?");
    $display("------------------------------------------------------");



    // Compare elements
    for (int i = 0; i < max_size; i++) begin

      // Ensure valid index access
      if (i >= data_gen.size() || i >= data_dut.size()) begin
        $error("Index out of bounds: i = %0d", i);
        break;
      end

      // Assign value inside the loop
      if (!data_gen[i].valid || !data_dut[i].valid) begin
        match_status = "-";  // Ignore padding values
      end else if (data_gen[i].data == data_dut[i].data) begin
        match_status = "yes";
      end else begin
        match_status = "no";
        mismatch_count++;
      end

      $display("%d\t\t%b\t%d\t   %b\t   %s", data_gen[i].data, data_gen[i].valid,
               data_dut[i].data, data_dut[i].valid, match_status);
    end

    // Print result
    if (mismatch_count) begin
      $display("\n\n\n---------------- Test Failed 👎👎--------------------------");
      $display("Total mismatches (excluding invalids): %0d", mismatch_count);
    end else begin
      $display("\n\n\n---------------- Test Passed!!⭐⭐ --------------------------\n\n\n");
    end
  endtask


endclass

class scoreboard #(
    DEPTH = 8,
    DATA_WIDTH = 8
);

  mailbox #(transaction) mon2sco;
  transaction tr;


  event done;  // to end simulation

  int gen_count = 0;
  int count = 0;
  int err = 0;
  int ptr;
  int temp;
  int actual[$];
  int expected[$];


  function new(mailbox#(transaction) b, int count);
    mon2sco = b;

    this.count = count;
  endfunction  //new()


  task run();
    tr = new();


    $display("\n\n\n-------------------FIFO behavior--------------------------");
    forever begin
      mon2sco.get(tr);  // second store the value comming from dut
      
      $display("[SCO📝] flags:  empty %d   full %d  data_out : %0d  contant: %p", tr.empty, tr.full,tr.data_out ,actual);


      // checking full flag  
      if (tr.full) begin
        if (actual.size() != DEPTH) begin
          $display("err full flag is not raised at %t ", $time);
          err++;
        end
      end else begin
        if (actual.size() == DEPTH) begin
          $display("err full flag is  raised while FIFO is not full %t ", $time);
          err++;
        end
      end


      // checking empty flag  
      if (tr.empty == 1) begin
        if (actual.size() != 0) begin
          $display("err empty flag is  raised while FIFO is not empty %t ", $time);
          err++;
        end
      end else begin
        if (actual.size() == 0) begin
          $display("err empty flag is not raised at %t ", $time);
          err++;
        end
      end


      // handel write 
      if (tr.w_en) begin

        if (tr.full == 0) begin
          actual.push_back(tr.data_in);
          expected.push_front(tr.data_in);
          //$display("[SCO📝] write %d to FIFO" , tr.data_in );
          ptr++;
        end


        gen_count++;
      end  
      
      //handel read 
      else if (tr.r_en) begin

        if (tr.empty == 0) begin
          temp = actual.pop_front();
          ptr--;

          if (temp != expected[ptr]) begin
            $display("epected %d but received %d  ", temp, expected[ptr]);
            err++;
          end
        end 
        gen_count++;
      end


      //$display("[SCO -debugging] :  Wr:%0d rd:%0d din:%0d dout:%0d full:%0d empty:%0d", tr.w_en, tr.r_en, tr.data_in, tr.data_out, tr.full, tr.empty);





      // extinig the loop
      if (count == gen_count - 1) begin
        ->done;
      end

    end

  endtask




  function void result;
    // Print result
    if (err) begin
      $display("\n\n\n---------------- Test Failed 👎👎--------------------------\n\n\n");
      $display("Total mismatches : %0d❌", err);
    end else begin
      $display("\n\n\n---------------- Test Passed!!⭐⭐ --------------------------\n\n\n");
    end
  endfunction


endclass

class monitor;

virtual fifo_if fif;
mailbox #(transaction) mon2sco;
transaction rx; 

    function new(mailbox #(transaction) a);
    
    mon2sco = a;

    endfunction //new()




    task  run;
        rx = new();
        
       forever  begin
        repeat(1)@(posedge fif.clk);
        rx.w_en = fif.w_en;
        rx.r_en = fif.r_en;
        rx.data_in = fif.data_in;
        rx.full     = fif.full;
        rx.empty    = fif.empty;
        rx.data_out = fif.data_out;
        repeat(1)@(negedge fif.clk);
        mon2sco.put(rx.copy);
        
        
       end 
    endtask 
endclass
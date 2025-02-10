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
        repeat(2)@(posedge fif.clk);
        rx.w_en = fif.w_en;
        rx.r_en = fif.r_en;
        rx.data_in = fif.data_in;
        rx.full     = fif.full;
        rx.empty    = fif.empty;
        @(posedge fif.clk);
        rx.data_out = fif.data_out;
        mon2sco.put(rx.copy);

        $display("[MON] : reset:%0d Wr:%0d rd:%0d din:%0d dout:%0d full:%0d empty:%0d",fif.rst_n, rx.w_en, rx.r_en, rx.data_in, rx.data_out, rx.full, rx.empty);
       end 
    endtask 
endclass
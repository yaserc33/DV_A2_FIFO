class driver;

virtual fifo_if fif;
mailbox gen2drv;
transaction tx;


    function new(mailbox a);
    gen2drv = a;

    endfunction //new()



    task  reset;
    fif.rst_n <= 1 ; 
    @posedge(fif.clk);
    fif.rst_n <= 0;
    $display("[drv] reset done..");
    endtask 

    task  write;
    fif.w_en <= 1 ; 
    fif.r_en <= 0;
    fif.data_in <= tx.data_in;
    $display("[drv] data sent to FIFO = %0dxa" , tx.data_in);
    @posedge(if.clk);
    fif.w_en <=0; 
    endtask 


    task  read;
    fif.w_en <= 0 ;
    fif.r_en <= 1;
    $display("[drv] read  requset sent to FIFO" );
    @posedge(if.clk);
    fif.r_en <=0; 
    endtask 


    task run();
     tx = new();
    forever begin
        gen2drv.get(tx);

        if (tx.rst_n) 
            reset();
        else if (tx.r_en)
            read();
        else 
            write();
    end
    endtask





endclass //driver
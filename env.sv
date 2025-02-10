class environment;
    
    generator gen;
    monitor mon ;
    driver drv;
    scoreboard sco;



    mailbox #(transaction) gen2drv ;
    mailbox #(transaction) gen2sco ;
    mailbox #(transaction) mon2sco ; 
    virtual fifo_if fif;

    event nextgs;
    int mode ;
    
    
    
    function new(virtual fifo_if a, int mode);

      gen2drv = new();
      gen2sco = new();
      mon2sco = new();
    //objects
      gen = new(gen2drv, gen2sco);
      drv= new(gen2drv);
      mon = new(mon2sco);
      sco = new (gen2sco,mon2sco);
    //intrfaces 
      fif = a;
      drv.fif = fif;
      mon.fif = fif;

    //event
    gen.next = nextgs;
    sco.next = nextgs;


    //select test
    this.mode = mode;


    endfunction

  
  
  task pre_test();
    fif.reset();
  endtask
  



  task test();
    fork
      gen.run(mode);
      drv.run();
      mon.run();
      sco.run();
    join_any
  endtask
  


  task post_test();
    wait(gen.done.triggered);  
    sco.result();

    #2000;
    $finish();
  endtask
  



  task run();
    pre_test();
    test();
    post_test();
  endtask








endclass //environment
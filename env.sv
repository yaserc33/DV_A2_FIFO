class environment;
    
    generator gen;
    monitor mon ;
    driver drv;
    scoreboard sco;



    mailbox gen2drv ;
    mailbox gen2soc ;
    mailbox mon2sco ; 
    virtual fifo_if fif;

    event next;
    int mode ;
    
    
    
    function new(virtual fifo_if a, int mode);

      gen2drv = new();
      gen2soc = new();
      mon2sco = new();
    //objects
      gen = new(gen2drv, gen2soc);
      drv= new(gen2drv);
      mon = new(mon2sco);
      sco = new (gen2sco,mon2sco);
    //intrfaces 
      fif = a;
      drv.fif = fif;
      mon.fif = fif;

    //event
    gen.next = next;
    sco.next = next;


    //select test
    this.mode = mode;


    endfunction

  
  
  task pre_test();
    drv.reset();
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
    $finish();
  endtask
  



  task run();
    pre_test();
    test();
    post_test();
  endtask








endclass //environment
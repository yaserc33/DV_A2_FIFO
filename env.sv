class environment;
    
    generator gen;
    monitor mon ;
    driver drv;
    scoreboard sco;



    mailbox #(transaction) gen2drv ;
    mailbox #(transaction) mon2sco ; 
    virtual fifo_if fif;

 
    int mode ; // to sellect which test gen will do  
    int count ; //to controll the number  of stimulus gen will generate then will be linked with soc to control when simulation end
    
    
    
    function new(virtual fifo_if fif, int mode , int count);

      gen2drv = new();
      mon2sco = new();
    //objects
      gen = new(gen2drv,count);
      drv= new(gen2drv);
      mon = new(mon2sco);
      sco = new (mon2sco,count);
    //intrfaces 
      this.fif = fif;
      drv.fif = this.fif;
      mon.fif = this.fif;

    



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
    wait(sco.done.triggered);  
    sco.result();
  endtask
  



  task run();
    pre_test();
    test();
    post_test();
    disable fork;
  endtask








endclass //environment
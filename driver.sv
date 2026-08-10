class my_driver extends uvm_driver #(trans);
  `uvm_component_utils(my_driver)
  virtual fifo_if vif;
  fifo_cfg cfg;

  function new(string name = "my_driver",
               uvm_component parent);
    super.new(name, parent);
  endfunction
  
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if (!uvm_config_db#(fifo_cfg)::get(this, "", "fifo_cfg", cfg))
       `uvm_fatal("NOcfg", "driver cant get cfg")
  endfunction
         function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif=cfg.vif;
  endfunction
       
       task run_phase(uvm_phase phase);
repeat(1)@(vif.drv_cb);
     forever begin 
  @(vif.drv_cb);
       seq_item_port.get_next_item(req);
     
       vif.drv_cb.wr_en<=req.wr_en;
       vif.drv_cb.wr_cs<=req.wr_cs;
       vif.drv_cb.rd_en<=req.rd_en;
       vif.drv_cb.rd_cs<=req.rd_cs;
       vif.drv_cb.data_in<=req.data_in;

        seq_item_port.item_done();
     end
     endtask
     endclass


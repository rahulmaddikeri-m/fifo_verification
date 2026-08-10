class input_agent extends uvm_agent;
	`uvm_component_utils(input_agent)
  my_driver drv1;
  input_monitor ipm;
 my_sequencer seqq;
  fifo_cfg cfg;
  function new(string name="active_agent",uvm_component parent);
	super.new(name,parent);
   endfunction
  function void  build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(fifo_cfg)::get(this,"","fifo_cfg",cfg))begin
       `uvm_fatal(get_type_name(),"inp agent getting failed");
end
       ipm=input_monitor::type_id::create("ipm",this);
       if(cfg.input_agent_is_active==UVM_ACTIVE)
         begin
         drv1=my_driver::type_id::create("drv1",this);
         seqq=my_sequencer::type_id::create("seqq",this);
         end
       endfunction
       function void connect_phase(uvm_phase phase);
	if(cfg.input_agent_is_active==UVM_ACTIVE)
	    begin
          drv1.seq_item_port.connect(seqq.seq_item_export);
	    end
 endfunction
       endclass


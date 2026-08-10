class output_agent extends uvm_agent;
	`uvm_component_utils(output_agent)
  output_monitor omp;
  fifo_cfg cfg;
    function new(string name="active_agent",uvm_component parent);
	super.new(name,parent);
   endfunction
  
  function void build_phase(uvm_phase phase);
	super.build_phase(phase);
    if(!uvm_config_db#(fifo_cfg)::get(this,"","fifo_cfg",cfg))begin
       `uvm_fatal(get_type_name(),"out agent getting failed");
end
       if(cfg.output_agent_is_passive==UVM_PASSIVE)
         begin
           omp=output_monitor::type_id::create("omp",this);
         end
       
       
  endfunction

 endclass
       


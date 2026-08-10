class fifo_cfg extends uvm_object;
  `uvm_object_utils(fifo_cfg);
  virtual fifo_if vif;
  uvm_active_passive_enum input_agent_is_active;
  uvm_active_passive_enum output_agent_is_passive;
   
  function new(string name="fifo_cfg");
	super.new(name);
  endfunction

endclass


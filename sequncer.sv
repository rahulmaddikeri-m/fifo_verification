  class my_sequencer extends uvm_sequencer #(trans);
  `uvm_component_utils(my_sequencer)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass


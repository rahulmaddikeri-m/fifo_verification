`include "define.sv"
class trans extends uvm_sequence_item;

  rand bit  wr_cs,rd_cs,wr_en,rd_en;
  rand  bit [`dw-1:0]data_in;
        bit [`dw-1:0]data_out;
         bit full,empty;


  `uvm_object_utils_begin(trans)
  `uvm_field_int(wr_cs,UVM_ALL_ON)
  `uvm_field_int(rd_cs,UVM_ALL_ON)
  `uvm_field_int(wr_en,UVM_ALL_ON)
  `uvm_field_int(rd_en,UVM_ALL_ON)
  `uvm_field_int(data_in,UVM_ALL_ON)
  `uvm_field_int(data_out,UVM_ALL_ON)
`uvm_field_int(full,UVM_ALL_ON)
`uvm_field_int(empty,UVM_ALL_ON)

  `uvm_object_utils_end
  
  
  function new(string name = "my_transaction");
    super.new(name);
  endfunction
endclass


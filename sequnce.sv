  class write_seq extends uvm_sequence#(trans);
  `uvm_object_utils(write_seq)
    function new(string name = "write_seq");
    super.new(name);
  endfunction
  
    task body();
    trans req;
repeat(10) begin
    req = trans::type_id::create("req");
    start_item(req);
      if(!req.randomize() with {wr_cs==1;wr_en==1;rd_cs==0;rd_en==0;})
         `uvm_error("SEQ", "write_seq randomize failed")
        finish_item(req);
end
  endtask
endclass
class read_seq extends uvm_sequence#(trans);
  `uvm_object_utils(read_seq)
  function new(string name = "read_seq");
    super.new(name);
  endfunction
  
    task body();
    trans req;
repeat(10)begin
    req = trans::type_id::create("req");
    start_item(req);
      if(!req.randomize() with {rd_cs==1;rd_en==1;wr_cs==0;wr_en==0;})
        `uvm_error("SEQ", "read_seq randomize failed")
        finish_item(req);
end
  endtask
endclass

class simul extends uvm_sequence#(trans);
  `uvm_object_utils(read_seq)
  function new(string name = "simul");
    super.new(name);
  endfunction
  
    task body();
    trans req;
repeat(10)begin
    req = trans::type_id::create("req");
    start_item(req);
      if(!req.randomize() with {rd_cs==1;rd_en==1;wr_cs==1;wr_en==1;})
        `uvm_error("SEQ", "simul randomize failed")
        finish_item(req);
end
  endtask
endclass
class wr_csonly extends uvm_sequence#(trans);
  `uvm_object_utils(read_seq)
  function new(string name = "wr_csonly");
    super.new(name);
  endfunction
  
    task body();
    trans req;
repeat(10)begin
    req = trans::type_id::create("req");
    start_item(req);
      if(!req.randomize() with {rd_cs==0;rd_en==0;wr_cs==1;wr_en==0;})
        `uvm_error("SEQ", "wr_cs randomize failed")
        finish_item(req);
end
  endtask
endclass
class rd_csonly extends uvm_sequence#(trans);
  `uvm_object_utils(read_seq)
  function new(string name = "rd_csonly");
    super.new(name);
  endfunction
  
    task body();
    trans req;
repeat(10)begin
    req = trans::type_id::create("req");
    start_item(req);
      if(!req.randomize() with {rd_cs==1;rd_en==0;wr_cs==0;wr_en==0;})
        `uvm_error("SEQ", "rd_csonly randomize failed")
        finish_item(req);
end
  endtask
endclass

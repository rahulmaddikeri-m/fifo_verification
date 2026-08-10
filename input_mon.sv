class input_monitor extends  uvm_monitor ;
  `uvm_component_utils(input_monitor)
  virtual fifo_if vif;
  trans drv2mon;
  fifo_cfg m_cfg;
  uvm_analysis_port #(trans) ap; 
covergroup fifo_cg ;

  wr_cs_cp: coverpoint vif.in_mon_cb.wr_cs;
  wr_en_cp: coverpoint vif.in_mon_cb.wr_en;

  rd_cs_cp: coverpoint vif.in_mon_cb.rd_cs;
  rd_en_cp: coverpoint vif.in_mon_cb.rd_en;

  data_in_cp: coverpoint vif.in_mon_cb.data_in{
      bins low  = {[0:85]};
      bins mid  = {[86:170]};
      bins high = {[171:255]};
    }

  wr_cross: cross wr_cs_cp, wr_en_cp;
  rd_cross: cross rd_cs_cp, rd_en_cp;

endgroup
  function new(string name="input_monitor",uvm_component parent);
	super.new(name,parent);
fifo_cg = new();
 endfunction

 function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(fifo_cfg)::get(this,"","fifo_cfg",m_cfg))begin
       `uvm_fatal(get_type_name(),"inp mon failed");
end
       ap=new("ap",this);
       endfunction
       
       function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
 	vif=m_cfg.vif;
     endfunction
       task  run_phase(uvm_phase phase);
  	
repeat(2)@(vif.in_mon_cb);
	forever begin
drv2mon=trans::type_id::create("drv2mon");

	    collect_input_monitor();
      //	`uvm_info("INPUT_MONITOR",$sformatf("Input MONITOR\n%s",drv2mon.sprint()),UVM_NONE)
	end
endtask

     task collect_input_monitor();

           @(vif.in_mon_cb);
           drv2mon.wr_en=vif.in_mon_cb.wr_en;
            drv2mon.wr_cs=vif.in_mon_cb.wr_cs;
            drv2mon.rd_cs=vif.in_mon_cb.rd_cs;
            drv2mon.rd_en=vif.in_mon_cb.rd_en;
            drv2mon.data_in=vif.in_mon_cb.data_in;
 fifo_cg.sample();
    	    ap.write(drv2mon);     
	endtask
     endclass


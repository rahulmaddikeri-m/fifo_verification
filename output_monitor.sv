class output_monitor extends  uvm_monitor ;
  `uvm_component_utils(output_monitor)
uvm_analysis_port#(trans) out_monitor_port;
  virtual fifo_if vif;
  trans data;
  fifo_cfg m_cfg;
   function new(string name="output_monitor",uvm_component parent);
	super.new(name,parent);
 endfunction

 
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(fifo_cfg)::get(this,"","fifo_cfg",m_cfg))begin
       `uvm_fatal(get_type_name(),"out mon failed");
end
       out_monitor_port=new("out_monitor_port",this);
       endfunction
       
       function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
 	vif=m_cfg.vif;
     endfunction
       
         task  run_phase(uvm_phase phase);
           
repeat(3)@(vif.out_mon_cb);
           forever begin
data=trans::type_id::create("data");
           collect_output_mon();
           //  `uvm_info("OUTPUT_MONITOR",$sformatf("Output MONITOR\n%s",data.sprint()),UVM_NONE)
end
             endtask
             task collect_output_mon();
               @(vif.out_mon_cb);
               data.data_out=vif.out_mon_cb.data_out;
               data.full=vif.out_mon_cb.full;
               data.empty=vif.out_mon_cb.empty;
 out_monitor_port.write(data);
             endtask
             endclass
             


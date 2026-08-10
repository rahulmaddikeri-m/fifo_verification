  class fifo_env extends uvm_env;
        `uvm_component_utils(fifo_env)
        scoreboard scb;
        output_agent out_agt;
        input_agent inp_agt;
 
        function new(string name="fifo_env",uvm_component parent);
                super.new(name,parent);
        endfunction
 
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                scb=scoreboard::type_id::create("scb",this);
                out_agt=output_agent::type_id::create("out_agt",this);
                inp_agt=input_agent::type_id::create("inp_agt",this);
        endfunction
 
        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                inp_agt.ipm.ap.connect(scb.inp_mon_fifo.analysis_export);
                out_agt.omp.out_monitor_port.connect(scb.out_mon_fifo.analysis_export);
        endfunction
 
endclass



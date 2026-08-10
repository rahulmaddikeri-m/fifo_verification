class test extends uvm_test;

  `uvm_component_utils(test)

  fifo_cfg m_conf;
  fifo_env env;

  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    m_conf = fifo_cfg::type_id::create("m_conf");

    if(!uvm_config_db#(virtual fifo_if)::get(this, "", "fifo_if", m_conf.vif)) begin
      `uvm_fatal(get_type_name(), "Can't get the interface")
    end

    m_conf.input_agent_is_active = UVM_ACTIVE;
    m_conf.output_agent_is_passive = UVM_PASSIVE;

    uvm_config_db#(fifo_cfg)::set(this, "*", "fifo_cfg", m_conf);

    env = fifo_env::type_id::create("env", this);

  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

endclass


class test1 extends test;

  `uvm_component_utils(test1)

  write_seq s1;
  read_seq s2;
function new(string name = "test1", uvm_component parent);
  super.new(name, parent);
endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    s1 = write_seq::type_id::create("s1");
    s2 = read_seq::type_id::create("s2");

   
     begin
        s1.start(env.inp_agt.seqq);
#25;
 s2.start(env.inp_agt.seqq);
      end
   

    #50;

    phase.drop_objection(this);

  endtask

endclass

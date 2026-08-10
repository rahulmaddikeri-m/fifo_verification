`include "define.sv"

class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

  uvm_tlm_analysis_fifo #(trans) inp_mon_fifo;
  uvm_tlm_analysis_fifo #(trans) out_mon_fifo;

  trans inp_mon;
  trans out_mon;

  virtual fifo_if vif;
  fifo_cfg m_cfg;

  bit [7:0] status_cnt;
  bit [7:0] wr_pointer;
  bit [7:0] rd_pointer;

  bit [`dw-1:0] ram_Depth[`depth];

  function new(string name="scoreboard", uvm_component parent);
    super.new(name,parent);
    inp_mon_fifo = new("inp_mon_fifo",this);
    out_mon_fifo = new("out_mon_fifo",this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(fifo_cfg)::get(this,"","fifo_cfg",m_cfg))
      `uvm_fatal("SCB","Cannot get fifo_cfg")

    vif = m_cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    fork
      input_process();
      output_process();
    join
  endtask

  task input_process();
    forever begin
      inp_mon_fifo.get(inp_mon);

      if(vif.rst) begin
        wr_pointer = 0;
        rd_pointer = 0;
        status_cnt = 0;
      end

      if(inp_mon.wr_cs && inp_mon.wr_en && status_cnt < `depth) begin

        ram_Depth[wr_pointer] = inp_mon.data_in;

        if(wr_pointer == `depth-1)
          wr_pointer = 0;
        else
          wr_pointer++;

        status_cnt++;

        `uvm_info("REFERENCE_MODEL",
          $sformatf("WRITE: DATA=%0h WR_PTR=%0d COUNT=%0d",inp_mon.data_in,wr_pointer,status_cnt),
          UVM_MEDIUM)
`uvm_info("INPUT_MONITOR data in scb ",$sformatf("Input MONITOR\n%s,%t",inp_mon.sprint(),$time),UVM_NONE)
      end
    end
  endtask

  task output_process();
    bit [`dw-1:0] expected_data;

    forever begin
      out_mon_fifo.get(out_mon);

      if(out_mon.empty == (status_cnt == 0))
        `uvm_info("SCB","EMPTY FLAG MATCH",UVM_MEDIUM)
      else
        `uvm_error("SCB",$sformatf("EMPTY FLAG MISMATCH: EXPECTED=%0d ACTUAL=%0d",
                    (status_cnt == 0),out_mon.empty))

      if(out_mon.full == (status_cnt == `depth))
        `uvm_info("SCB","FULL FLAG MATCH",UVM_MEDIUM)
      else
        `uvm_error("SCB",$sformatf("FULL FLAG MISMATCH: EXPECTED=%0d ACTUAL=%0d",
                    (status_cnt == `depth),out_mon.full))

      if(out_mon.rd_cs && out_mon.rd_en && status_cnt > 0) begin

        expected_data = ram_Depth[rd_pointer];

        if(expected_data == out_mon.data_out)
          `uvm_info("SCB",$sformatf("DATA MATCH: EXPECTED=%0h ACTUAL=%0h",
                      expected_data,out_mon.data_out),
            UVM_MEDIUM)
        else
          `uvm_error("SCB",$sformatf("DATA MISMATCH: EXPECTED=%0h ACTUAL=%0h",
                      expected_data,out_mon.data_out))

        if(rd_pointer == `depth-1)
          rd_pointer = 0;
        else
          rd_pointer++;

        status_cnt--;
      end
`uvm_info("output_MONITOR data in scb ",$sformatf("out MONITOR\n%s,%t",out_mon.sprint(),$time),UVM_NONE)
    end
  endtask

endclass

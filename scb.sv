`include "define.sv"

class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

  uvm_tlm_analysis_fifo #(trans) inp_mon_fifo;
  uvm_tlm_analysis_fifo #(trans) out_mon_fifo;

  trans inp_mon;
  trans out_mon;

  virtual fifo_if vif;
  fifo_cfg m_cfg;

  bit [`dw-1:0] expected_q[$];
  bit [`dw-1:0] read_expected_q[$];

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

    bit [`dw-1:0] expected_data;

    forever begin

      inp_mon_fifo.get(inp_mon);

      if(vif.rst) begin
        expected_q.delete();
        read_expected_q.delete();
      end

      if(inp_mon.wr_cs &&
         inp_mon.wr_en &&
         expected_q.size() < `depth) begin

        expected_q.push_back(inp_mon.data_in);

        `uvm_info("REFERENCE_MODEL",
          $sformatf(
          "WRITE: DATA=%0h QUEUE_SIZE=%0d",
          inp_mon.data_in,
          expected_q.size()),
          UVM_MEDIUM)

        `uvm_info("INPUT_MONITOR data in scb",
          $sformatf(
          "Input MONITOR\n%s,%t",
          inp_mon.sprint(),
          $time),
          UVM_NONE)

      end

      if(inp_mon.rd_cs &&
         inp_mon.rd_en &&
         expected_q.size() > 0) begin

        expected_data = expected_q.pop_front();

        read_expected_q.push_back(expected_data);

        `uvm_info("REFERENCE_MODEL",
          $sformatf(
          "READ: EXPECTED DATA=%0h QUEUE_SIZE=%0d",
          expected_data,
          expected_q.size()),
          UVM_MEDIUM)

      end

    end

  endtask


  task output_process();

    bit [`dw-1:0] expected_data;

    forever begin

      out_mon_fifo.get(out_mon);

      if(read_expected_q.size() > 0) begin

        expected_data = read_expected_q.pop_front();

        if(expected_data == out_mon.data_out)

          `uvm_info("SCB",
            $sformatf(
            "DATA MATCH: EXPECTED=%0h ACTUAL=%0h",
            expected_data,
            out_mon.data_out),
            UVM_MEDIUM)

        else

          `uvm_error("SCB",
            $sformatf(
            "DATA MISMATCH: EXPECTED=%0h ACTUAL=%0h",
            expected_data,
            out_mon.data_out))

      end

      if(out_mon.empty == (expected_q.size() == 0))

        `uvm_info("SCB",
          "EMPTY FLAG MATCH",
          UVM_MEDIUM)

      else

        `uvm_error("SCB",
          $sformatf(
          "EMPTY FLAG MISMATCH: EXPECTED=%0d ACTUAL=%0d",
          (expected_q.size() == 0),
          out_mon.empty))


      if(out_mon.full == (expected_q.size() == `depth))

        `uvm_info("SCB",
          "FULL FLAG MATCH",
          UVM_MEDIUM)

      else

        `uvm_error("SCB",
          $sformatf(
          "FULL FLAG MISMATCH: EXPECTED=%0d ACTUAL=%0d",
          (expected_q.size() == `depth),
          out_mon.full))


      `uvm_info("OUTPUT_MONITOR data in scb",
        $sformatf(
        "out MONITOR\n%s,%t",
        out_mon.sprint(),
        $time),
        UVM_NONE)

    end

  endtask

endclass

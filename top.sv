`include "test_pkg.sv"
`include "interface.sv"
//`include "ram_dp_ar_aw.sv"
`include "syn_fifo.sv"

import uvm_pkg::*;
import test_pkg::*;
module top;
  bit clk;
  bit rst;
fifo_if duv_if(clk,rst);
syn_fifo duv_fifo(
  .clk      (duv_if.clk),
  .rst      (duv_if.rst),
  .wr_cs    (duv_if.wr_cs),
  .rd_cs    (duv_if.rd_cs),
  .wr_en    (duv_if.wr_en),
  .rd_en    (duv_if.rd_en),
  .data_in  (duv_if.data_in),
  .data_out (duv_if.data_out),
  .full     (duv_if.full),
  .empty    (duv_if.empty)
);
  	initial
	begin
		uvm_config_db#(virtual fifo_if)::set(null,"*","fifo_if",duv_if);
		$dumpfile("waves.fsdb");
		  $dumpvars;

	        run_test("test1");
		
	end

	initial
	begin
		clk=1'b0;
		forever 
		   #5 clk=~clk;
	end
  initial begin
#1;rst =1;
    #5;
    rst=0;
  end
endmodule



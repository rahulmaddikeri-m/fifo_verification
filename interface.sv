`include "define.sv"
interface fifo_if(input clk,rst);
  logic wr_cs,rd_cs,wr_en,rd_en;
  logic [`dw-1:0]data_in;
  logic [`dw-1:0]data_out;
  logic full,empty;
  
 logic [7:0] status_cnt;
  
  clocking drv_cb@(posedge clk);
    default  input #1 output #1;
    output wr_cs,wr_en,rd_cs,rd_en,data_in;
  endclocking
  
  clocking out_mon_cb@(posedge clk);
    default  input #1 output #1;
    input data_out,full,empty;
  endclocking
  
   clocking in_mon_cb@(posedge clk);
    default  input #1 output #1;
    input  wr_cs,wr_en,rd_cs,rd_en,data_in;
  endclocking
  
  modport dr_v(clocking drv_cb);
   modport in_mon(clocking in_mon_cb);
    modport out_mon(clocking out_mon_cb);
   endinterface


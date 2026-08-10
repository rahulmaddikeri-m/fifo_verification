module ram_dp_ar_aw (
clk       , // Clock (write path only -- see note above)
address_0 , // Port 0 address (write side, from syn_fifo)
data_0    , // Port 0 data (bidirectional)
cs_0      , // Port 0 chip select
we_0      , // Port 0 write enable
oe_0      , // Port 0 output enable
address_1 , // Port 1 address (read side, from syn_fifo)
data_1    , // Port 1 data (bidirectional)
cs_1      , // Port 1 chip select
we_1      , // Port 1 write enable
oe_1        // Port 1 output enable
);

// Parameters -- order must match the instantiation in syn_fifo.v:
// ram_dp_ar_aw #(DATA_WIDTH, ADDR_WIDTH) DP_RAM (...)
parameter DATA_WIDTH = 8;
parameter ADDR_WIDTH = 8;
parameter RAM_DEPTH  = (1 << ADDR_WIDTH);

// Port Declarations
input                    clk       ;
input  [ADDR_WIDTH-1:0]  address_0 ;
inout  [DATA_WIDTH-1:0]  data_0    ;
input                    cs_0      ;
input                    we_0      ;
input                    oe_0      ;

input  [ADDR_WIDTH-1:0]  address_1 ;
inout  [DATA_WIDTH-1:0]  data_1    ;
input                    cs_1      ;
input                    we_1      ;
input                    oe_1      ;

//-----------Internal variables-------------------
reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];
reg [DATA_WIDTH-1:0] data_0_out ;
reg [DATA_WIDTH-1:0] data_1_out ;

//-----------------------------------------------------
// PORT 0 : synchronous (edge-triggered) write
// -- see header note: intentionally NOT level-sensitive,
//    to eliminate a same-edge race with syn_fifo.v
//-----------------------------------------------------
always @ (posedge clk)
begin : PORT0_WRITE
  if (cs_0 && we_0) begin
    mem[address_0] <= data_0;
  end
end

//-----------------------------------------------------
// PORT 0 : asynchronous (combinational) read + tri-state
//-----------------------------------------------------
always @ (cs_0 or oe_0 or address_0)
begin : PORT0_READ
  if (cs_0 && oe_0) begin
    data_0_out = mem[address_0];
  end else begin
    data_0_out = {DATA_WIDTH{1'bz}};
  end
end
assign data_0 = (cs_0 && oe_0 && !we_0) ? data_0_out : {DATA_WIDTH{1'bz}};

//-----------------------------------------------------
// PORT 1 : synchronous (edge-triggered) write
// -- unused by syn_fifo.v (we_1 tied low there), kept
//    consistent with port 0 for generality / reuse
//-----------------------------------------------------
always @ (posedge clk)
begin : PORT1_WRITE
  if (cs_1 && we_1) begin
    mem[address_1] <= data_1;
  end
end

//-----------------------------------------------------
// PORT 1 : asynchronous (combinational) read + tri-state
//-----------------------------------------------------
always @ (cs_1 or oe_1 or address_1)
begin : PORT1_READ
  if (cs_1 && oe_1) begin
    data_1_out = mem[address_1];
  end else begin
    data_1_out = {DATA_WIDTH{1'bz}};
  end
end
assign data_1 = (cs_1 && oe_1 && !we_1) ? data_1_out : {DATA_WIDTH{1'bz}};

endmodule


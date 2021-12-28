module NEXYS4_DDR
(
      input   CLK100MHZ
    , input   CPU_RESETN
    
    , input   BTNC
    , input   [15:0] SW
    , output  [15:0] LED

    , input   UART_TXD_IN
    , output  UART_RXD_OUT
);

//`define TEST_NO_OPS       // baseline
//`define TEST_XOR_ONE_STAGE  // optimized
//`define TEST_ADD_ONE_STAGE    // not optimized
`define TEST_XOR_DIFF_STAGES  // not optimized
//`define TEST_ADD_DIFF_STAGES  // not optimized
//`define TEST_XOR_DIFF_STAGES_ENB  // not optimized
//`define TEST_ADD_DIFF_STAGES_ENB  // not optimized

wire clk_gen;
assign clk_gen = CLK100MHZ;

logic modif_buf;
logic [7:0] data0_buf, data1_buf;
always @(posedge clk_gen) if (!CPU_RESETN) modif_buf <= 0; else modif_buf <= UART_TXD_IN;
always @(posedge clk_gen) if (!CPU_RESETN) data0_buf <= 0; else data0_buf <= SW[7:0];
always @(posedge clk_gen) if (!CPU_RESETN) data1_buf <= 0; else data1_buf <= SW[15:8];

logic modif_st0;
logic [7:0] data0_st0, data1_st0;
always @(posedge clk_gen) if (!CPU_RESETN) modif_st0 <= 0; else modif_st0 <= modif_buf;
`ifdef TEST_NO_OPS              always @(posedge clk_gen) if (!CPU_RESETN) data0_st0 <= 0; else data0_st0 <= data0_buf; `endif
`ifdef TEST_XOR_ONE_STAGE       always @(posedge clk_gen) if (!CPU_RESETN) data0_st0 <= 0; else data0_st0 <= data0_buf ^ data1_buf ^ data1_buf; `endif
`ifdef TEST_ADD_ONE_STAGE       always @(posedge clk_gen) if (!CPU_RESETN) data0_st0 <= 0; else data0_st0 <= data0_buf + data1_buf - data1_buf; `endif
`ifdef TEST_XOR_DIFF_STAGES     always @(posedge clk_gen) if (!CPU_RESETN) data0_st0 <= 0; else data0_st0 <= data0_buf ^ data1_buf; `endif
`ifdef TEST_ADD_DIFF_STAGES     always @(posedge clk_gen) if (!CPU_RESETN) data0_st0 <= 0; else data0_st0 <= data0_buf + data1_buf; `endif
`ifdef TEST_XOR_DIFF_STAGES_ENB always @(posedge clk_gen) if (!CPU_RESETN) data0_st0 <= 0; else if (modif_buf) data0_st0 <= data0_buf ^ data1_buf; else data0_st0 <= data0_buf; `endif
`ifdef TEST_ADD_DIFF_STAGES_ENB always @(posedge clk_gen) if (!CPU_RESETN) data0_st0 <= 0; else if (modif_buf) data0_st0 <= data0_buf + data1_buf; else data0_st0 <= data0_buf; `endif
always @(posedge clk_gen) if (!CPU_RESETN) data1_st0 <= 0; else data1_st0 <= data1_buf;

logic modif_st1;
logic [7:0] data0_st1, data1_st1;
always @(posedge clk_gen) if (!CPU_RESETN) modif_st1 <= 0; else modif_st1 <= modif_st0;
`ifdef TEST_NO_OPS              always @(posedge clk_gen) if (!CPU_RESETN) data0_st1 <= 0; else data0_st1 <= data0_st0; `endif
`ifdef TEST_XOR_ONE_STAGE       always @(posedge clk_gen) if (!CPU_RESETN) data0_st1 <= 0; else data0_st1 <= data0_st0; `endif
`ifdef TEST_ADD_ONE_STAGE       always @(posedge clk_gen) if (!CPU_RESETN) data0_st1 <= 0; else data0_st1 <= data0_st0; `endif
`ifdef TEST_XOR_DIFF_STAGES     always @(posedge clk_gen) if (!CPU_RESETN) data0_st1 <= 0; else data0_st1 <= data0_st0 ^ data1_st0; `endif
`ifdef TEST_ADD_DIFF_STAGES     always @(posedge clk_gen) if (!CPU_RESETN) data0_st1 <= 0; else data0_st1 <= data0_st0 - data1_st0; `endif
`ifdef TEST_XOR_DIFF_STAGES_ENB always @(posedge clk_gen) if (!CPU_RESETN) data0_st1 <= 0; else if (modif_st0) data0_st1 <= data0_st0 ^ data1_st0; else data0_st1 <= data0_st0; `endif
`ifdef TEST_ADD_DIFF_STAGES_ENB always @(posedge clk_gen) if (!CPU_RESETN) data0_st1 <= 0; else if (modif_st0) data0_st1 <= data0_st0 - data1_st0; else data0_st1 <= data0_st0; `endif
always @(posedge clk_gen) if (!CPU_RESETN) data1_st1 <= 0; else data1_st1 <= data1_st0;

assign LED[7:0] = data0_st1;
assign LED[15:8] = data1_st1;

endmodule

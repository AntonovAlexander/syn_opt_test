/*
 * riscv_tb.sv
 *
 *  Created on: 24.09.2017
 *      Author: Alexander Antonov <antonov.alex.alex@gmail.com>
 *     License: See LICENSE file for details
 */


`timescale 1ns / 1ps

`define HALF_PERIOD			5						//external 100 MHZ
`define DIVIDER_115200		32'd8680
`define DIVIDER_19200		32'd52083
`define DIVIDER_9600		32'd104166
`define DIVIDER_4800		32'd208333
`define DIVIDER_2400		32'd416666


module tb ();
//
logic CLK_100MHZ, RSTN;
wire [31:0] SW;
wire [31:0] LED;

initial
    begin
    CLK_100MHZ = 1'b1;
    RSTN = 0;
    datain0 = 0;
    datain1 = 1;
    @(posedge CLK_100MHZ);
    RSTN <= 1;
    end

logic enb;
logic modif;
logic [7:0] datain0, datain1, dataout0, dataout1;
assign SW = {datain0, datain1};
assign dataout0 = LED[7:0];
assign dataout1 = LED[15:8];
	
NEXYS4_DDR NEXYS4_DDR
(
	.CLK100MHZ(CLK_100MHZ)
	, .CPU_RESETN(RSTN)
	, .BTNC(enb)
	, .UART_TXD_IN(modif)
	//, .tx_o()
	, .SW(SW)
	, .LED(LED)
);
//
always #`HALF_PERIOD CLK_100MHZ = ~CLK_100MHZ;

always @(posedge CLK_100MHZ)
    begin
    enb     <= $urandom();
    modif   <= $urandom();
    datain0 <= datain0 + 2;
    datain1 <= datain1 + 2;
    end

initial
    begin
    #1400;
    $stop();
    end
//
endmodule

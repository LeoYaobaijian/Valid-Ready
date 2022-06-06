`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/05 13:43:01
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench(
);
reg clear;
reg sys_clk;
reg sys_rst_n;
reg master_out;
reg data_in_vld_1;
reg slave_rdy;
reg data_out;

wire data_in_rdy_1;
wire data_in_rdy_2;
wire data_out_1;
wire data_out_2;
wire data_out_vld_1;
wire data_out_vld_2;

always #10 sys_clk <= ~sys_clk;
always #20 master_out <= ~master_out;
always #80 slave_rdy <= ~slave_rdy;

initial begin
    sys_clk <= 1'b0;
    master_out <= 1'b0;
    clear <= 1'b0;
    sys_rst_n <= 1'b1;
    data_in_vld_1 <= 1'b1;
    slave_rdy <= 1'b1;
    $finish;
end

MiddlePipe #(.DW(1)) Pipe1(
    .Clk(sys_clk),
    .Clear(clear),
    .Rstn(sys_rst_n),
    .DataIn(master_out),
    .DataInVld(data_in_vld_1),
    .DataInRdy(data_in_rdy_1),
    .DataOut(data_out_1),
    .DataOutVld(data_out_vld_1),
    .DataOutRdy(data_in_rdy_2)
);

MiddlePipe #(.DW(2)) Pipe2(
    .Clk(sys_clk),
    .Clear(clear),
    .Rstn(sys_rst_n),
    .DataIn(data_out_1),
    .DataInVld(data_out_vld_1),
    .DataInRdy(data_in_rdy_2),
    .DataOut(data_out_2),
    .DataOutVld(data_out_vld_2),
    .DataOutRdy(slave_rdy)
);

endmodule

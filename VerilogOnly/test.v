module MiddlePipe #(parameter
    DW = 8
)(
    input           Clk         ,
    input           Clear       ,
    input           Rstn        ,

    input  [DW-1:0] DataIn      ,
    input           DataInVld   ,
    output          DataInRdy   ,

    output [DW+1:0] DataOut     ,
    output          DataOutVld  ,
    input           DataOutRdy
);

reg data_in_rdy;
assign DataInRdy = data_in_rdy;

reg [DW+1:0] data_out;
assign DataOut = data_out;

reg data_out_vld;
assign DataOutVld = data_out_vld;

always @ *
begin
    data_in_rdy = DataOutRdy || ~data_out_vld; 
end

always @( posedge Clk or negedge Rstn )
begin
    if( ~Rstn )
        data_out <= 'h0;
    else if( Clear )
        data_out <= 'h0;
    else
        data_out <= ( data_in_rdy && DataInVld ) ? DataIn : data_out;
end

always @( posedge Clk or negedge Rstn )
begin
    if( ~Rstn )
        data_out_vld <= 'h0;
    else if( Clear )
        data_out_vld <= 'h0;
    else
        data_out_vld <= data_in_rdy ? DataInVld : data_out_vld;
end

endmodule

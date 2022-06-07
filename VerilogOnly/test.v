module MiddlePipe #(parameter
    DW = 8
)(
    //pherpheral
    input           Clk         ,
    input           Clear       ,
    input           Rstn        ,
    //in interface
    input  [DW-1:0] DataIn      ,
    input           DataInVld   ,
    output          DataInRdy   ,
    //out interface
    output [DW-1:0] DataOut     ,
    output          DataOutVld  ,
    input           DataOutRdy  ,
    
    output          O_accept    , 
    output          Transmit        
);


reg data_in_rdy;
assign DataInRdy = data_in_rdy;

reg [DW-1:0] data_out;
assign DataOut = data_out;

reg data_out_vld;
assign DataOutVld = data_out_vld;

//Control

parameter EMPTY = 3'b001;
parameter BUSY  = 3'b010;
parameter FULL  = 3'b100;

reg accept, transmit;
reg [2:0] state, next_state;  
reg [DW-1:0] buffer;   

assign O_accept = accept;
assign Transmit = transmit;

always @ *
begin
    accept     = DataInRdy && DataInVld;  // check for input handshake
    transmit   = DataOutVld && DataOutRdy;  // check for output handshake
    next_state = EMPTY;
    case (state)
    EMPTY: begin
        next_state = EMPTY;
        if (accept) next_state = BUSY;
    end
    BUSY: begin
        next_state = BUSY;
        if (accept && !transmit) next_state = FULL;
        else if (!accept && transmit) next_state = EMPTY;
    end
    FULL: begin
        next_state = FULL;
        if (transmit) next_state = BUSY;
    end
    default: next_state = EMPTY;
    endcase
end

always @( posedge Clk or negedge Rstn )
begin
    if( ~Rstn || Clear)  begin
        state          <= EMPTY;
        data_in_rdy    <= 1'b0;
        data_out_vld   <= 'h0;
    end else begin
        state          <= next_state;
        data_in_rdy    <= next_state != FULL;
        data_out_vld   <= next_state != EMPTY;
    end
end


reg buffer_write_en, o_data_write_en;
always  @ *  
begin
    buffer_write_en = (state == BUSY && accept && !transmit);
    o_data_write_en = (state == EMPTY && accept && !transmit)
                  || (state == BUSY && accept && transmit)
                  || (state == FULL && !accept && transmit);
end

always @( posedge Clk or negedge Rstn )
begin
    $display(o_data_write_en, " ", buffer_write_en);
    if( ~Rstn || Clear ) begin
        data_out <= 'h0;
        buffer <= 'h0;
    end else begin
        if (o_data_write_en) begin
           if (state == FULL) begin
                data_out <= buffer;  
           end else begin
                data_out <= DataIn;
           end
        end
        if (buffer_write_en) begin
            buffer <= DataIn;
        end

    end
end
endmodule

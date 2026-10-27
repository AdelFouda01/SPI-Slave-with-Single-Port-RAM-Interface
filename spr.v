module spr ( din ,rx_valid , clk , rst_n , dout , tx_valid  ) ;

parameter  MEM_DEPTH = 256 ,
           ADDR_SIZE = 8   ;

input  [9:0] din ;
input  clk , rst_n , rx_valid ;

output reg tx_valid ;
output reg [7:0] dout ;

reg [7:0] mem [MEM_DEPTH-1:0] ;
reg [ADDR_SIZE-1:0] rd_addr,wr_addr ;



always @(posedge clk) begin
    if (!rst_n)begin 
        tx_valid <= 0 ;
        dout <= 0 ;
    end
    else begin 
      tx_valid <= 1'b0;
        case (din[9:8])
            2'b00 : if (rx_valid) wr_addr <= din[7:0] ;
            2'b01 : if (rx_valid) mem[wr_addr] <= din[7:0] ;
            2'b10 : if (rx_valid) rd_addr <= din[7:0] ;
            2'b11 : begin if(rx_valid) begin  dout <= mem[rd_addr] ; tx_valid <= 1 ; end end 
    endcase   
    end
    
end
endmodule







/*

always @(posedge clk) begin
    if (!rst_n) begin
        addr      <= 0 ;
        addr_flag <= 0 ;
        dout      <= 0 ;
        tx_valid  <= 0 ;
    end
    else begin
        tx_valid <= 0 ;

        if (rx_valid) begin
            if (!din[8]) begin
                addr      <= din[7:0] ;
                addr_flag <= 1'b1 ;
            end
            else if (din[8] && addr_flag) begin
                if (!din[9]) begin
                    mem[addr] <= din[7:0] ;
                    addr_flag <= 1'b0 ;
                end
                else begin
                    dout      <= mem[addr] ;
                    tx_valid  <= 1'b1 ;
                    addr_flag <= 1'b0 ;
                end
            end
        end
    end
end

endmodule */
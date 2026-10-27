module SPI_Wrapper (
    input  wire MOSI,
    input  wire SS_n,
    input  wire clk,
    input  wire rst,
    output wire MISO
);

    // Internal wires interconnecting SPI Slave and Single Port RAM
    wire [9:0] rx_data;
    wire       rx_valid;
    wire [7:0] tx_data;
    wire       tx_valid;

  
    SPI_Slave spi_slave (
        .MOSI(MOSI),
        .SS_n(SS_n),
        .clk(clk),
        .rst_n(rst),
        .tx_data(tx_data),
        .tx_valid(tx_valid),
        .MISO(MISO),
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );

    
    spr ram (
        .din(rx_data),
        .rx_valid(rx_valid),
        .clk(clk),
        .rst_n(rst),
        .dout(tx_data),
        .tx_valid(tx_valid)
    );

endmodule
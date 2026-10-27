module SPI_Slave (
    input  wire       MOSI,
    input  wire       SS_n,
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tx_valid,
    input  wire [7:0] tx_data,
    output reg        MISO,
    output reg        rx_valid,
    output reg  [9:0] rx_data
);

    // State Encoding
    localparam IDLE      = 3'b000;
    localparam CHK_CMD   = 3'b001;
    localparam WRITE     = 3'b010;
    localparam READ_ADD  = 3'b011;
    localparam READ_DATA = 3'b100;

(* fsm_encoding = "gray" *)
    reg [2:0] cs, ns;
    reg [4:0] bit_counter;      
    reg       rd_addr_received;
    reg [7:0] tx_data_reg;     

    
    // 1. State Register
    always @(posedge clk ) begin
        if (!rst_n)
            cs <= IDLE;
        else
            cs <= ns;
    end

    // 2. Next State Logic
    always @(*) begin
        case (cs)
            IDLE: begin
                if (!SS_n)
                    ns = CHK_CMD;
                else
                    ns = IDLE;
            end

            CHK_CMD: begin
                if (SS_n)
                    ns = IDLE;
                else if (MOSI == 1'b0)
                    ns = WRITE;
                else begin
                    if (!rd_addr_received)
                        ns = READ_ADD;
                    else
                        ns = READ_DATA;
                end
            end

            WRITE: begin
                if (SS_n) ns = IDLE;
                else      ns = WRITE;
            end

            READ_ADD: begin
                if (SS_n) ns = IDLE;
                else      ns = READ_ADD;
            end

            READ_DATA: begin
                if (SS_n) ns = IDLE;
                else      ns = READ_DATA;
            end

            default: ns = IDLE;
        endcase
    end

    // 3. Output & Counter Logic
    always @(posedge clk ) begin
        if (!rst_n) begin
            rx_data          <= 10'd0;
            rx_valid         <= 1'b0;
            MISO             <= 1'b0;
            bit_counter      <= 5'd0;
            rd_addr_received <= 1'b0;
        end else begin
            rx_valid <= 1'b0;

            case (cs)
                IDLE: begin
                    bit_counter <= 5'd0;
                    MISO        <= 1'b0;
                    rx_data     <= 10'd0;
                end

                CHK_CMD: begin
                    bit_counter <= 5'd0;
                end

                WRITE: begin
                    rx_data <= {rx_data[8:0], MOSI};
                    if (bit_counter == 5'd9) begin
                        rx_valid    <= 1'b1;
                        bit_counter <= 5'd0;
                    end else begin
                        bit_counter <= bit_counter + 1'b1;
                    end
                end

                READ_ADD: begin
                    rx_data <= {rx_data[8:0], MOSI};
                    if (bit_counter == 5'd9) begin
                        rx_valid         <= 1'b1;
                        bit_counter      <= 5'd0;
                        rd_addr_received <= 1'b1;
                    end else begin
                        bit_counter <= bit_counter + 1'b1;
                    end
                end

               READ_DATA: begin
    
    if (bit_counter <= 5'd9) begin
        rx_data <= {rx_data[8:0], MOSI};
        if (bit_counter == 5'd9) begin
            rx_valid <= 1'b1; 
        end
        bit_counter <= bit_counter + 1'b1;
    end

   
    else if (bit_counter == 5'd10) begin
       
        MISO        <= tx_data[7]; 
        bit_counter <= bit_counter + 1'b1;
    end

   
    else if (bit_counter >= 5'd11 && bit_counter <= 5'd17) begin
        MISO        <= tx_data[5'd17 - bit_counter];
        bit_counter <= bit_counter + 1'b1;
    end

    
    else if (bit_counter == 5'd18) begin
        MISO             <= 1'b0;
        rd_addr_received <= 0;
        bit_counter      <= 5'd0;
    end
end
            endcase
        end
    end

endmodule
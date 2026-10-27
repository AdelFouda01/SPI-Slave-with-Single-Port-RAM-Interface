`timescale 1ns/1ps

module SPI_tb ; 

reg  MOSI, SS_n, clk, rst;
wire MISO ;   

// Instantiation
SPI_Wrapper DUT (
    .MOSI(MOSI),
    .SS_n(SS_n),
    .clk(clk),
    .rst(rst),
    .MISO(MISO)
);

// Clock Generation (Period = 10ns)
initial begin
    clk = 0 ;
    forever begin
        #5 clk = ~clk ;  
    end
end

initial begin
    
    MOSI = 0 ;
    rst  = 0 ; 
    SS_n = 1 ;

    
    $readmemb("mem1.txt", DUT.ram.mem) ;

   
    @(negedge clk) ; 
    rst  = 1 ; 
    SS_n = 0 ; 

    // --- Transaction 1: Write Address ---
    @(negedge clk) ; 
    MOSI = 0 ; 
    
    repeat (2) begin
        @(negedge clk);
        MOSI = 0 ;
    end
            
    repeat(8) begin 
        @(negedge clk) ; 
        MOSI = $random  ;
    end
    SS_n = 1 ;

    // --- Transaction 2: Write Data ---
    @(negedge clk) ;         
    SS_n = 0 ;

    @(negedge clk) ;         
    MOSI = 0 ;

    @(negedge clk) ;         
    MOSI = 0 ;

    @(negedge clk) ;    
    MOSI = 1 ;   

    repeat(8) begin 
        @(negedge clk) ; 
        MOSI = $random  ;
    end
    SS_n = 1 ;

    // --- Transaction 3: Read Address ---
    @(negedge clk) ;         
    SS_n = 0 ;

    @(negedge clk) ;         
    MOSI = 1 ;

    @(negedge clk) ;
    MOSI = 1 ;

    @(negedge clk) ;
    MOSI = 0 ;

    repeat(8) begin 
        @(negedge clk) ; 
        MOSI = $random  ;
    end
    SS_n = 1 ;

    // --- Transaction 4: Read Data ---
    @(negedge clk) ;         
    SS_n = 0 ;

    @(negedge clk) ;         
    MOSI = 1 ;

    @(negedge clk) ; 
    MOSI = 1 ;

    @(negedge clk) ;
    MOSI = 1 ;   

    repeat(8) begin 
        @(negedge clk) ; 
        MOSI = $random  ;
    end

     repeat (8) @(negedge clk) ;
     
      
    SS_n = 1 ;

   
    
end 

endmodule
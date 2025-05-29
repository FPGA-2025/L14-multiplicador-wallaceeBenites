module Multiplier #(
    parameter N = 4
) (
    input wire clk,
    input wire rst_n,

    input wire start,
    output reg ready,

    input wire   [N-1:0] multiplier,
    input wire   [N-1:0] multiplicand,
    output reg [2*N-1:0] product
);


    reg [N-1:0]   multiplier_reg;  
    reg [2*N-1:0] multiplicand_reg; 
    reg [2*N-1:0] product_reg;      
    reg [N:0]     counter;         

    
    parameter IDLE  = 2'b00;
    parameter COMPUTE = 2'b01;
    parameter DONE  = 2'b10;
    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            
            state <= IDLE;
            ready <= 0;
            product <= 0;
            multiplier_reg <= 0;
            multiplicand_reg <= 0;
            product_reg <= 0;
            counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                       
                        multiplier_reg <= multiplier;
                        multiplicand_reg <= {{N{1'b0}}, multiplicand}; 
                        product_reg <= 0;
                        counter <= 0;
                        ready <= 0;
                        state <= COMPUTE;
                    end
                end

                COMPUTE: begin
                    if (counter < N) begin
                       
                        if (multiplier_reg[0]) begin
                            product_reg <= product_reg + multiplicand_reg;
                        end

                        
                        multiplicand_reg <= multiplicand_reg << 1;
                        multiplier_reg <= multiplier_reg >> 1;

                       
                        counter <= counter + 1;
                    end else begin
                        
                        product <= product_reg;
                        ready <= 1;
                        state <= DONE;
                    end
                end

                DONE: begin
                    ready <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule











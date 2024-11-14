module Asynch_fifo (
    input wr_clk,           // Write clock
    input rd_clk,           // Read clock
    input rst,              // Asynchronous reset
    input rd_enb,           // Read enable
    input wr_enb,           // Write enable
    input [7:0] data_in,    // Data input
    output reg [7:0] data_out, // Data output
    output full,            // Full flag
    output empty            // Empty flag
);

    parameter depth = 16;             // FIFO depth
    reg [7:0] mem [depth-1:0];        // Memory array for FIFO
    reg [4:0] rd_ptr, wr_ptr;         // Read and write pointers
    integer i;

    // Write logic
    always @(posedge wr_clk or posedge rst) 
    begin
        if (rst)
        begin
            wr_ptr <= 5'd0;
            // Initialize the memory array
            for (i = 0; i < depth; i = i + 1)
                mem[i] <= 8'd0;
        end 
        else if (!full && wr_enb) 
        begin
            mem[wr_ptr[3:0]] <= data_in;  // Write data to memory
            wr_ptr <= wr_ptr + 1;         // Increment write pointer
        end
    end

    // Read logic
    always @(posedge rd_clk or posedge rst)
     begin
        if (rst) begin
            rd_ptr <= 5'd0;
            data_out <= 8'dx;
        end
        else if (!empty && rd_enb) 
        begin
            data_out <= mem[rd_ptr[3:0]];  // Read data from memory
            rd_ptr <= rd_ptr + 1;          // Increment read pointer
        end
    end

    // Empty and Full flag logic
    assign empty = (rd_ptr == wr_ptr);  // FIFO is empty when read pointer equals write pointer
    assign full = (wr_ptr[4:0]==5'b10000 && rd_ptr[4:0]==5'b00000) ? 1'b1 : 1'b0;  // FIFO is full when pointers match with MSB inversion

endmodule


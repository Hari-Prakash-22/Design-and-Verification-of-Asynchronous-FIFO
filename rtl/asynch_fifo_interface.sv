interface fifo_if(input wr_clk,rd_clk);
	logic [7:0]data_in,data_out;
	bit rst,empty,full,wr_enb,rd_enb;
// source driver cb

clocking SRC_DRV_CB@(posedge wr_clk);
	default input #1 output #0;
	input full;
	output wr_enb,rst,data_in;
endclocking

//source monitor cb

clocking SRC_MON_CB@(posedge wr_clk);
	default input #2 output #0;
	input full,wr_enb,rst,data_in;
endclocking

//destination drv
clocking DST_DRV_CB@(posedge rd_clk);
	default input #1 output #0;
	input empty;
	output rd_enb;
endclocking


//destination monitor cb

clocking DST_MON_CB@(posedge rd_clk);
	default input #1 output #0;
	input empty,data_out,rst,rd_enb;
endclocking



//mordport 
modport SRC_DRV(clocking SRC_DRV_CB);
modport SRC_MON(clocking SRC_MON_CB);
modport DST_DRV(clocking DST_DRV_CB);
modport DST_MON(clocking DST_MON_CB);


endinterface:fifo_if	

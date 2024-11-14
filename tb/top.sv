module top();
	import test_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	bit wr_clk,rd_clk;
	
	initial
	begin
		wr_clk = 0;
		rd_clk = 0;
		fork
			forever #5 wr_clk=~wr_clk;

			forever #10 rd_clk=~rd_clk;
		join
	end
	fifo_if vif(wr_clk,rd_clk);
 
Asynch_fifo dut(.wr_clk(vif.wr_clk),
		.rd_clk(vif.rd_clk),
		.rst(vif.rst),
		.wr_enb(vif.wr_enb),
		.rd_enb(vif.rd_enb),
		.data_in(vif.data_in),
		.data_out(vif.data_out),
		.full(vif.full),
		.empty(vif.empty));
			
	







	initial 
	begin
	`ifdef VCS
        	 $fsdbDumpvars(0, top);
       	`endif
	uvm_config_db#(virtual fifo_if)::set(null,"*","fifo_if",vif);
	run_test("");
	end
endmodule



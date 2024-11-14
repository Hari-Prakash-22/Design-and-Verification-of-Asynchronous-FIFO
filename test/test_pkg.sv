package test_pkg;


	//import uvm_pkg.sv
	
	import uvm_pkg::*;
	

		
	//include uvm_macros.sv
	//include all other files
	`include "uvm_macros.svh"
//	`include "tb_defs.sv"
	`include "wr_xtn.sv"
	`include "rd_xtn.sv"
//	`include "event.sv"
	`include "wr_agent_cfg.sv"
	`include "rd_agent_cfg.sv"
	`include "env_cfg.sv"

	`include "wr_drv.sv"
	`include "wr_mon.sv"
	`include "wr_seq.sv"
	`include "wr_seqr.sv"
	`include "wr_agent.sv"
	`include "wr_agent_top.sv"
	

	`include "rd_mon.sv"
	`include "rd_seqr.sv"
	`include "rd_seq.sv"
	`include "rd_drv.sv"
	`include "rd_agent.sv"
	`include "rd_agent_top.sv"

	`include "v_seqr.sv"
	`include "v_seq.sv"
	`include "scoreboard.sv"

	`include "env.sv"


	`include "test.sv"
	
endpackage


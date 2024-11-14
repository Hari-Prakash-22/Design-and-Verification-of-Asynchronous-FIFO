class wr_seqr extends uvm_sequencer#(wr_xtn);
	`uvm_component_utils(wr_seqr)


	extern function new(string name="wr_seqr",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass


function wr_seqr::new(string name="wr_seqr",uvm_component parent);
	super.new(name,parent);
endfunction 


function void wr_seqr::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction



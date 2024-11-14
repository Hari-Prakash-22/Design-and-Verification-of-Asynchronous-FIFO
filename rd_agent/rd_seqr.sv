class rd_seqr extends uvm_sequencer#(rd_xtn);
	`uvm_component_utils(rd_seqr)


	extern function new(string name="rd_seqr",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass


function rd_seqr::new(string name="rd_seqr",uvm_component parent);
	super.new(name,parent);
endfunction 


function void rd_seqr::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction


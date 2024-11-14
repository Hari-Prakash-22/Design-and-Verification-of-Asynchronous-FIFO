class wr_agent_cfg extends uvm_object;
	`uvm_object_utils(wr_agent_cfg)
	
	virtual fifo_if vif;
	uvm_active_passive_enum is_active=UVM_ACTIVE;
	extern function new(string name="wr_agent_cfg");
endclass
function wr_agent_cfg::new(string name="wr_agent_cfg");
	super.new(name);
endfunction

class env_cfg extends uvm_object;
	`uvm_object_utils(env_cfg)

	wr_agent_cfg wr_agent_cfgh;
	rd_agent_cfg rd_agent_cfgh;
	bit has_wagent = 1;
	bit has_sb=1;
	bit has_ragent = 1;
	bit has_virtual_sequencer;

	extern function new(string name="env_cfg");
endclass

function env_cfg::new(string name="env_cfg");
	super.new(name);
endfunction

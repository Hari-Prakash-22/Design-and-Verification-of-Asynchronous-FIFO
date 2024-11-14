class wr_agent_top extends uvm_env;
	`uvm_component_utils(wr_agent_top)

	wr_agent wr_agenth;
	env_cfg env_cfgh;
	wr_agent_cfg wr_agent_cfgh;

	extern function new(string name="wr_agent_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass

function wr_agent_top::new(string name="wr_agent_top",uvm_component parent);
	super.new(name,parent);
endfunction

function void wr_agent_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(env_cfg)::get(this,"","env_cfg",env_cfgh))
		`uvm_fatal(get_type_name(),"Couldn't get the env cfg")
	uvm_config_db#(wr_agent_cfg)::set(this,"*","wr_agent_cfg",env_cfgh.wr_agent_cfgh);
	wr_agenth=wr_agent::type_id::create("wr_agenth",this);
endfunction	

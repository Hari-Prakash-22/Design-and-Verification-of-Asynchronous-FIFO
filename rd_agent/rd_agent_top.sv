class rd_agent_top extends uvm_env;
	`uvm_component_utils(rd_agent_top)

	rd_agent rd_agenth;
	rd_agent_cfg rd_agent_cfgh;
	env_cfg env_cfgh;

	extern function new(string name="rd_agent_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void start_of_simulation_phase(uvm_phase phase);
endclass

function rd_agent_top::new(string name="rd_agent_top",uvm_component parent);
	super.new(name,parent);
endfunction

function void rd_agent_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db#(env_cfg)::get(this,"","env_cfg",env_cfgh))
		`uvm_fatal(get_type_name(),"couldn't get the env cfg in rd_agent top")
	uvm_config_db#(rd_agent_cfg)::set(this,"*","rd_agent_cfg",env_cfgh.rd_agent_cfgh);
	rd_agenth=rd_agent::type_id::create("rd_agenth",this);
endfunction	

function void rd_agent_top::start_of_simulation_phase(uvm_phase phase);
	super.report_phase(phase);
	uvm_top.print_topology();
endfunction

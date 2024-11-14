class env extends uvm_env;
	`uvm_component_utils(env)

	env_cfg env_cfgh;
	
	wr_agent_top wr_agent_toph;
	rd_agent_top rd_agent_toph;
	rd_agent_cfg rd_agent_cfgh;
	virtual_sequencer v_seqrh;
	scoreboard sb_h;
	extern function new(string name="env",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

function env::new(string name="env",uvm_component parent);
	super.new(name,parent);
endfunction


function void env::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(env_cfg)::get(this,"","env_cfg",env_cfgh))
		`uvm_fatal(get_type_name(),"Couldn't get the env_cfg")
	
	if(env_cfgh.has_wagent==1)
	begin
		wr_agent_toph=wr_agent_top::type_id::create("wr_agent_toph",this);
	end
	if(env_cfgh.has_ragent==1)
	begin
		rd_agent_toph=rd_agent_top::type_id::create("rd_agent_toph",this);
	end
	if(env_cfgh.has_sb == 1)
	begin
			sb_h=scoreboard::type_id::create("sb_h",this);
	end
	if(env_cfgh.has_virtual_sequencer==1)
	begin	
		v_seqrh=virtual_sequencer::type_id::create("v_seqrh",this);
	end
endfunction
 
function void env::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	v_seqrh.rd_seqrh=rd_agent_toph.rd_agenth.rd_seqrh;
	v_seqrh.wr_seqrh=wr_agent_toph.wr_agenth.wr_seqrh;

	if(env_cfgh.has_sb == 1)
	begin
		wr_agent_toph.wr_agenth.wr_monh.wr_mon_port.connect(sb_h.wr_mon_xtn.analysis_export);
		rd_agent_toph.rd_agenth.rd_monh.rd_mon_port.connect(sb_h.rd_mon_xtn.analysis_export);
	end
endfunction

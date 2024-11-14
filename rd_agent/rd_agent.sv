class rd_agent extends uvm_agent;
	`uvm_component_utils(rd_agent)

	rd_drv rd_drvh;
	rd_mon rd_monh;
	rd_seqr rd_seqrh;
	rd_agent_cfg rd_agent_cfgh;

	extern function new(string name="rd_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

function rd_agent::new(string name="rd_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void rd_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(rd_agent_cfg)::get(this,"","rd_agent_cfg",rd_agent_cfgh))
		`uvm_fatal(get_type_name(),"couldn't get rd agent config")


	rd_monh=rd_mon::type_id::create("rd_monh",this);
	if(rd_agent_cfgh.is_active==UVM_ACTIVE)
	begin
	rd_drvh=rd_drv::type_id::create("rd_drvh",this);
	rd_seqrh=rd_seqr::type_id::create("rd_seqrh",this);
	end
endfunction

function void rd_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(rd_agent_cfgh.is_active==UVM_ACTIVE)
	begin
	rd_drvh.seq_item_port.connect(rd_seqrh.seq_item_export);
	end
endfunction

class wr_agent extends uvm_agent;
	`uvm_component_utils(wr_agent)

	wr_drv wr_drvh;
	wr_mon wr_monh;
	wr_seqr wr_seqrh;
	wr_agent_cfg wr_agent_cfgh;

	extern function new(string name="wr_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

function wr_agent::new(string name="wr_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void wr_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(wr_agent_cfg)::get(this,"","wr_agent_cfg",wr_agent_cfgh))
		`uvm_fatal(get_type_name(),"couldn't get the wr agent cfg")

	wr_monh=wr_mon::type_id::create("wr_monh",this);
	if(wr_agent_cfgh.is_active==UVM_ACTIVE)
	begin
	wr_drvh=wr_drv::type_id::create("wr_drvh",this);
	wr_seqrh=wr_seqr::type_id::create("wr_seqrh",this);
	end
endfunction

function void wr_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(wr_agent_cfgh.is_active==UVM_ACTIVE)
	begin
	wr_drvh.seq_item_port.connect(wr_seqrh.seq_item_export);
	end
endfunction


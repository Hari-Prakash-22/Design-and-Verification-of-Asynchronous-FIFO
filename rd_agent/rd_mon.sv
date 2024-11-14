class rd_mon extends uvm_monitor;
	`uvm_component_utils(rd_mon)

	rd_xtn xtnh;
	virtual fifo_if.DST_MON vif;
	rd_agent_cfg rd_agent_cfgh;

	uvm_analysis_port#(rd_xtn) rd_mon_port;

	extern function new(string name="rd_mon",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
endclass


function rd_mon::new(string name="rd_mon",uvm_component parent);
	super.new(name,parent);
	rd_mon_port= new("rd_mon_port", this);
endfunction 


function void rd_mon::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(rd_agent_cfg)::get(this,"","rd_agent_cfg",rd_agent_cfgh))
		`uvm_fatal(get_type_name(),"couldn't get the interface name")
endfunction

function void rd_mon::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	this.vif = rd_agent_cfgh.vif;
endfunction

task rd_mon::run_phase(uvm_phase phase);
	super.run_phase(phase);
	// @(vif.DST_MON_CB);
	forever collect_data();
endtask

task rd_mon::collect_data();
	//repeat(1)
	@(vif.DST_MON_CB);

	xtnh=rd_xtn::type_id::create("rd_MON_xtnh");
	
	`uvm_info(get_full_name(),"this the rd mon data",UVM_LOW)
	
	while(vif.DST_MON_CB.empty !== 1'b0)
		@(vif.DST_MON_CB);
	
//	repeat(3)
//	@(vif.DST_MON_CB);
	xtnh.data_out = vif.DST_MON_CB.data_out;
	xtnh.rd_enb = vif.DST_MON_CB.rd_enb; 

	`uvm_info(get_type_name(),$sformatf("rd_xtnh = %0s", xtnh.sprint()),UVM_NONE)
	rd_mon_port.write(xtnh);
endtask
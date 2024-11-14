class wr_mon extends uvm_monitor;
	`uvm_component_utils(wr_mon)

	virtual fifo_if.SRC_MON vif;
	wr_agent_cfg wr_agent_cfgh;
	wr_xtn xtnh;
	uvm_analysis_port#(wr_xtn) wr_mon_port;
	extern function new(string name="wr_mon",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
endclass


function wr_mon::new(string name="wr_mon",uvm_component parent);
	super.new(name,parent);
	wr_mon_port=new("wr_mon_port",this);
endfunction 


function void wr_mon::build_phase(uvm_phase phase);
	if(!uvm_config_db#(wr_agent_cfg)::get(this,"","wr_agent_cfg",wr_agent_cfgh))
		`uvm_fatal(get_type_name(),"couldn't get the config in monitor")
	super.build_phase(phase);
endfunction

function void wr_mon::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=wr_agent_cfgh.vif;
endfunction

task wr_mon::run_phase(uvm_phase phase);
	super.run_phase(phase);
	repeat(3)
		@(vif.SRC_MON_CB);
	forever 
		collect_data();
endtask

task wr_mon::collect_data();
	
	repeat(1)
	@(vif.SRC_MON_CB);

	xtnh=wr_xtn::type_id::create("wr_MON_xtnh");
	
	`uvm_info(get_full_name(),"this the wr mon data",UVM_LOW)
	
	while(vif.SRC_MON_CB.full !== 1'b0)
		@(vif.SRC_MON_CB);
	
//	repeat(3)
//	@(vif.SRC_MON_CB);
	xtnh.data_in = vif.SRC_MON_CB.data_in;
	xtnh.wr_enb = vif.SRC_MON_CB.wr_enb; 

	`uvm_info(get_type_name(),$sformatf("wr_xtnh = %0s",xtnh.sprint()),UVM_NONE)
	wr_mon_port.write(xtnh);
endtask

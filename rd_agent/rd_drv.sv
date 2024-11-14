class rd_drv extends uvm_driver#(rd_xtn);
	`uvm_component_utils(rd_drv)
	virtual fifo_if.DST_DRV vif;
	rd_agent_cfg rd_agent_cfgh;

	
	extern function new(string name="rd_drv",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut();
endclass


function rd_drv::new(string name="rd_drv",uvm_component parent);
	super.new(name,parent);
endfunction 


function void rd_drv::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(rd_agent_cfg)::get(this,"","rd_agent_cfg",rd_agent_cfgh))
		`uvm_fatal(get_type_name(),"couldn't get the interface name")
endfunction

function void rd_drv::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	this.vif = rd_agent_cfgh.vif;
endfunction

task rd_drv::run_phase(uvm_phase phase);
	super.run_phase(phase);
	// @(vif.DST_DRV_CB);
	forever
	send_to_dut();
endtask

task rd_drv::send_to_dut();
	//`uvm_info(get_type_name(),"this is the read driver xtn",UVM_LOW)
	while(vif.DST_DRV_CB.empty !== 1'b0)
	begin
		@(vif.DST_DRV_CB);
//		$display("fifo is full");
	end
	@(vif.DST_DRV_CB); //changed 
	vif.DST_DRV_CB.rd_enb <= 1'b1;
	repeat(1)
	@(vif.DST_DRV_CB);
endtask
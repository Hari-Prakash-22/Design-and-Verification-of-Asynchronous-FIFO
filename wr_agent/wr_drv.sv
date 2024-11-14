class wr_drv extends uvm_driver#(wr_xtn);
	`uvm_component_utils(wr_drv)
	virtual fifo_if.SRC_DRV vif;
	wr_agent_cfg wr_agent_cfgh;

	extern function new(string name="wr_drv",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(wr_xtn xtn);
endclass


function wr_drv::new(string name="wr_drv",uvm_component parent);
	super.new(name,parent);
endfunction 


function void wr_drv::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(wr_agent_cfg)::get(this,"","wr_agent_cfg",wr_agent_cfgh))
		`uvm_fatal(get_type_name(),"couldn't get the interface name")
endfunction

function void wr_drv::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=wr_agent_cfgh.vif;
endfunction

task wr_drv::run_phase(uvm_phase phase);
	super.run_phase(phase);

	@(vif.SRC_DRV_CB);
		vif.SRC_DRV_CB.rst<=1'b1; 
	@(vif.SRC_DRV_CB);
		vif.SRC_DRV_CB.rst<=1'b0;
	@(vif.SRC_DRV_CB);
		//vif.SRC_DRV_CB.wr_enb<=1'b1; 
	
	forever
		begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
		end
endtask

task wr_drv::send_to_dut(wr_xtn xtn);
	`uvm_info(get_type_name(),"this is the write driver xtn",UVM_LOW)

	while(vif.SRC_DRV_CB.full !== 1'b0)
	begin
		@(vif.SRC_DRV_CB);
		$display("fifo is full");
	end
	//$display("before mon");
	vif.SRC_DRV_CB.data_in<=xtn.data_in;
	vif.SRC_DRV_CB.wr_enb<=1'b1; 

	//$display("after mon");
	xtn.print();
		//repeat(2)	
	@(vif.SRC_DRV_CB);
	//vif.SRC_DRV_CB.data_in<='bx;
	//vif.SRC_DRV_CB.wr_enb<='bx; 

endtask


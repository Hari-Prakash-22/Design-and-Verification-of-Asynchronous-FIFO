class test extends uvm_test;
	`uvm_component_utils(test)

	wr_agent_cfg wr_agent_cfgh;
	rd_agent_cfg rd_agent_cfgh;
	env_cfg env_cfgh;
	env envh;
	int vcount=18;
	bit has_ragent=1;
	bit has_wagent=1;
	bit has_sb=1;
	bit has_vseqr=1;


	extern function new(string name="test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function test::new(string name="test",uvm_component parent);
	super.new(name,parent);
		env_cfgh=env_cfg::type_id::create("env_cfgh");
		
endfunction


function void test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(has_wagent==1)
	begin
		wr_agent_cfgh=wr_agent_cfg::type_id::create("wr_agent_cfgh");	
		wr_agent_cfgh.is_active=UVM_ACTIVE;
		if(!uvm_config_db#(virtual fifo_if)::get(this,"","fifo_if",wr_agent_cfgh.vif))
			`uvm_fatal(get_type_name(),"couldn't get the vif for wr agent")

		env_cfgh.wr_agent_cfgh=wr_agent_cfgh;
		

	end
	if(has_ragent==1)
	begin

		rd_agent_cfgh=rd_agent_cfg::type_id::create("rd_agent_cfgh");
		rd_agent_cfgh.is_active=UVM_ACTIVE;
		if(!uvm_config_db#(virtual fifo_if)::get(this,"","fifo_if",rd_agent_cfgh.vif))
			`uvm_fatal(get_type_name(),"couldn't get the vif for rd_agent")
		env_cfgh.rd_agent_cfgh=rd_agent_cfgh;
	end
	env_cfgh.has_ragent=has_ragent;
	env_cfgh.has_wagent=has_wagent;
	env_cfgh.has_sb=has_sb;
	env_cfgh.has_virtual_sequencer=has_vseqr;

	uvm_config_db#(env_cfg)::set(this,"*","env_cfg",env_cfgh);

	//for vcount the virtual sequence and scoreboard to repeat and count that many times
	uvm_config_db#(int)::set(this,"*","int",vcount);
	envh=env::type_id::create("envh",this);
endfunction

task test::run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask
class test1 extends test;

	`uvm_component_utils(test1)
	
	v_seq1 v_seq1_h;


	extern function new(string name = "test1",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass
function test1::new(string name="test1",uvm_component parent);
	super.new(name,parent);
endfunction
function void test1::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction
task test1::run_phase(uvm_phase phase);
	super.run_phase(phase);
	begin
	v_seq1_h=v_seq1::type_id::create("seq1_h");
	phase.raise_objection(this);
		v_seq1_h.start(envh.v_seqrh);

		if(has_sb == 1)
			wait(envh.sb_h.DONE.triggered);
		else
	 		#180;
		`uvm_info(get_type_name(),"done event just triggered!!!!!!!!!!!!!!",UVM_LOW)
	phase.drop_objection(this);
	
	end
	
endtask


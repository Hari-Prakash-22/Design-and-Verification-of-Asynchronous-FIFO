class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

	uvm_tlm_analysis_fifo#(wr_xtn)wr_mon_xtn;
	uvm_tlm_analysis_fifo#(rd_xtn)rd_mon_xtn;
    rd_xtn rd_xtnh;
    wr_xtn wr_xtnh;
    bit [7:0] q1[$],q2[$];
    bit [7:0] a,b;

    int vcount;

    event DONE;
    static int count=0;

    //covergroups -

    covergroup wr_cg;
        option.per_instance = 1;
        DATA_IN: coverpoint wr_xtnh.data_in{
                bins a = {[0:50]};
                bins b = {[50:100]};
                bins c = {[100:150]};
                bins d = {[150:200]};
        }
    endgroup

    covergroup rd_cg;
        option.per_instance = 1;
        DATA_OUT: coverpoint rd_xtnh.data_out{
                bins a = {[0:50]};
                bins b = {[50:100]};
                bins c = {[100:150]};
                bins d = {[150:200]};
        }
    endgroup


    //methods
    extern function new(string name="scoreboard",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    //extern task collect_data(rd_xtn rd_cxtn,wr_xtn wr_cxtn);
    extern task que_check();
endclass

function scoreboard::new(string name="scoreboard",uvm_component parent);
            super.new(name,parent);
            wr_cg = new();
            rd_cg = new();
            wr_mon_xtn=new("wr_mon_port",this);
            rd_mon_xtn=new("rd_mon_port",this);
endfunction

function void scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(int)::get(this,"","int",vcount))
        `uvm_fatal(get_full_name(), "config getting failed");
endfunction

task scoreboard::run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever
    begin
        fork
            begin
                wr_mon_xtn.get(wr_xtnh);
                q1.push_back(wr_xtnh.data_in);
                wr_cg.sample();
                `uvm_info(get_type_name(),$sformatf("wr_xtnh = %0s",wr_xtnh.sprint()),UVM_NONE)
            end
            begin
                // #6;
                // `uvm_info(get_type_name(),$sformatf("In begin end of rd mon time = %0t",$time),UVM_NONE)

                rd_mon_xtn.get(rd_xtnh);
                 if(rd_xtnh.data_out !== 8'bx)
                 begin
                     q2.push_back(rd_xtnh.data_out);
                     que_check();
                     rd_cg.sample();
                 end
                `uvm_info(get_type_name(),$sformatf("rd_xtnh = %0s",rd_xtnh.sprint()),UVM_NONE)
                // `uvm_info(get_type_name(),"the both data is matched",UVM_LOW)
               // collect_data(rd_xtnh,wr_xtnh);
            end
        join
    end
endtask


/*task scoreboard::collect_data(rd_xtn rd_cxtn,wr_xtn wr_cxtn);
   // int i=1;
    if(rd_cxtn.data_out == wr_cxtn.data_in)
    begin
         `uvm_info(get_type_name(),"the both data is matched",UVM_NONE)
         count++;
        `uvm_info(get_type_name(),$sformatf(" inside collect data rd_xtnh = %0s\n\n wr_xtnh = %0s \n\n\n\n\n\n\n\ncount=%0d",rd_cxtn.sprint(), wr_cxtn.sprint(),count),UVM_NONE)
    end
    else
        `uvm_info(get_type_name(),$sformatf(" inside collect data rd_xtnh = %0s\n\n wr_xtnh = %0s",rd_cxtn.sprint(), wr_cxtn.sprint()),UVM_NONE)
    begin
    
    end
    // else
    //     $display("data not matched");
    //     `uvm_info(get_type_name(),"the both data is not matched",UVM_NONE)
    if(count == 1)
    begin

        //  `uvm_info(get_type_name(),"going to trigger the done event",UVM_NONE)
        ->DONE;
    end
endtask*/
task scoreboard::que_check();
a=q1.pop_front;
b=q2.pop_front;

if(a==b)
begin
    `uvm_info(get_type_name(),"the data gets matched",UVM_NONE)
    count++;
    `uvm_info(get_type_name(),$sformatf(" count=%0d",count),UVM_NONE)
end
 else
 begin
     `uvm_info(get_type_name(),"the data doesn't gets matched",UVM_NONE)
    ->DONE;
 end
/*foreach(q1[i])
    begin   
        if(q1[i]==q2[i])
                `uvm_info(get_type_name(),"the data gets matched",UVM_NONE)
        else
            `uvm_info(get_type_name(),"the data doesn't gets matched",UVM_NONE)
    end*/
if(count == vcount)
    ->DONE;
endtask

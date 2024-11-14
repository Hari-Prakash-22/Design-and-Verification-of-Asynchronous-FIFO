class wr_seq extends uvm_sequence#(wr_xtn);
	`uvm_object_utils(wr_seq)

	int length;


	extern function new(string name="wr_seq");
	extern task body();
endclass

function wr_seq::new(string name="wr_seq");
	super.new(name);
endfunction
 
task wr_seq::body();
	super.body();
endtask

class seq_1 extends wr_seq;
	`uvm_object_utils(seq_1)

	extern function new(string name="seq_1");
	extern task body();
endclass

function seq_1::new(string name="seq_1");
	super.new(name);
endfunction

task seq_1::body();
	super.body();
	begin
	
req=wr_xtn::type_id::create("req");

	//for(int i=0;i<2;i++)
	begin
	start_item(req);
	assert(req.randomize() with {data_in inside {40, 70, 120, 170};});
	// $display("no of trans= %0d",i);
	//req.print();
	finish_item(req);
	end


end
endtask
	

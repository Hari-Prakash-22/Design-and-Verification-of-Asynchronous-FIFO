class wr_xtn extends uvm_sequence_item;
	`uvm_object_utils(wr_xtn)

	rand bit [7:0] data_in;
	bit wr_enb;
	bit full;
	rand bit [4:0]sot;//size of transfer

	constraint c2{sot==15;}
	constraint c1{data_in inside {[0:200]};}



	extern function new(string name="wr_xtn");
	extern function void do_print(uvm_printer printer);
endclass


function wr_xtn::new(string name="wr_xtn");
	super.new(name);
endfunction

function void wr_xtn::do_print(uvm_printer printer);
	super.do_print(printer);


	printer.print_field("size_of_tranfer",this.sot,5,UVM_DEC);
	printer.print_field("data_in",this.data_in,8,UVM_DEC);
	printer.print_field("wr_enb",this.wr_enb,1,UVM_DEC);
	printer.print_field("full",this.full,1,UVM_DEC);
endfunction

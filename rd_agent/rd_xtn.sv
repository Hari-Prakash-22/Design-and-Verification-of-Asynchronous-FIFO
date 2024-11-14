class rd_xtn extends uvm_sequence_item;
	`uvm_object_utils(rd_xtn)

	logic [7:0]data_out;
	bit empty,rd_enb;



	extern function new(string name="rd_xtn");
	extern function void do_print(uvm_printer printer);
endclass

function rd_xtn::new(string name="rd_xtn");
	super.new(name);
endfunction

function void rd_xtn::do_print(uvm_printer printer);
	super.do_print(printer);


	printer.print_field("Data_out",this.data_out,8,UVM_DEC);
	printer.print_field("Empty",this.empty,1,UVM_DEC);
	printer.print_field("rd_enb",this.rd_enb,1,UVM_DEC);
endfunction

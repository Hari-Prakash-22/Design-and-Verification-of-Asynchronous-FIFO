class virtual_sequence extends uvm_sequence#(uvm_sequence_item);
    `uvm_object_utils(virtual_sequence)

    virtual_sequencer v_seqrh;
    rd_seqr rd_seqrh;
    wr_seqr wr_seqrh;

    int vcount;

    extern function new(string name="virtual_sequence");
    extern task body();
endclass

function virtual_sequence::new(string name="virtual_sequence");
    super.new(name);
endfunction

task virtual_sequence::body();
    if(!$cast(v_seqrh,m_sequencer))
        `uvm_fatal(get_type_name(),"the sequencer is incompatible")
    
    rd_seqrh=v_seqrh.rd_seqrh;
    wr_seqrh=v_seqrh.wr_seqrh;
endtask

class v_seq1 extends virtual_sequence;
    `uvm_object_utils(v_seq1)
        int i;
    	seq_1 v_seq1_h;

        extern function new(string name="v_seq1");
        extern task body();
endclass


function v_seq1::new(string name="v_seq1");
    super.new(name);
endfunction


task v_seq1::body();
    super.body();
    v_seq1_h = seq_1::type_id::create("Seq1");
    if(!uvm_config_db#(int)::get(null,get_full_name(),"int",vcount))
        `uvm_fatal(get_full_name(), "config getting failed");
    repeat(vcount)
    begin
        i++;
        v_seq1_h.start(wr_seqrh);// no need to start the rd sequencer because it is an passive one
        $display("no of trans= %0d",i);
    end
endtask
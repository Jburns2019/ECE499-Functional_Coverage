//Spec. 4
covergroup cg_reset @(posedge tb.clk, posedge tb.reset);
    cp_reset: coverpoint tb.reset {
        bins reset = {1};
    }
    cp_accmodule: coverpoint tb.accmodule {
        bins M1_to_idle = (2'b01 => '0);
        bins M2_to_idle = (2'b10 => '0);
        bins M3_to_idle = (2'b11 => '0);
    }
    cp_both: cross cp_reset, cp_accmodule;
endgroup

//Spec. 5
covergroup cg_M1_interrupts @(posedge tb.clk, posedge tb.req[0]);
    cp_accmodule: coverpoint tb.accmodule {
        bins M2_to_M1 = (2'b10 => 2'b01);
        bins M3_to_M1 = (2'b11 => 2'b01);
    }
endgroup

//Spec. 6
covergroup cg_all_modules_requestable @(posedge tb.clk);
    cp_req: coverpoint tb.req {
        wildcard bins req_M1 = {3'b??1};
        wildcard bins req_M2 = {3'b?1?};
        wildcard bins req_M3 = {3'b1??};
    }
    cp_accmodule: coverpoint tb.accmodule {
        wildcard bins to_M1 = (2'b?? => 2'b01);
        wildcard bins to_M2 = (2'b?? => 2'b10);
        wildcard bins to_M3 = (2'b?? => 2'b11);
    }
    cp_both: cross cp_req, cp_accmodule {
        option.cross_auto_bin_max = 0;

        bins M1_req_acted_on = binsof(cp_req.req_M1) && binsof(cp_accmodule.to_M1);
        bins M2_req_acted_on = binsof(cp_req.req_M2) && binsof(cp_accmodule.to_M2);
        bins M3_req_acted_on = binsof(cp_req.req_M3) && binsof(cp_accmodule.to_M3);
    }
endgroup

//Spec. 7
covergroup cg_req_for_cycle @(posedge tb.clk);
    cp_req: coverpoint tb.req {
        wildcard illegal_bins still_req_M1 = (3'b??1 => 3'b??1 => 3'b??1);
        illegal_bins still_req_M2 = (3'b010 => 3'b010 => 3'b010);
        illegal_bins still_req_M3 = (3'b100 => 3'b100 => 3'b100);

        wildcard bins for_sure_happens = {3'b???};
    }
endgroup

//Spec. 8
covergroup cg_req_M1_acted_on_edge @(posedge tb.req[0], posedge tb.accmodule[0] or negedge tb.accmodule[1]);
    cp_clk: coverpoint tb.clk {
        bins pos_clk = {1};
        bins neg_clk = {0};
    }
    cp_accmodule_to_M1: coverpoint tb.accmodule {
        bins idle_to_M1 = (2'b00 => 2'b01);
        bins M2_to_M1 = (2'b10 => 2'b01);
        bins M3_to_M1 = (2'b11 => 2'b01);
    }
    cp_immidiate_chage: cross cp_clk, cp_accmodule_to_M1 {
        bins proper_change_to_M1 = binsof(cp_clk.pos_clk) && binsof(cp_accmodule_to_M1);
        illegal_bins improper_change_to_M1 = binsof(cp_clk.neg_clk) && binsof(cp_accmodule_to_M1);
    }
endgroup
covergroup cg_req_M2_acted_on_edge @(posedge tb.req[1], posedge tb.accmodule[1] or negedge tb.accmodule[0]);
    cp_clk: coverpoint tb.clk {
        bins pos_clk = {1};
        bins neg_clk = {0};
    }
    cp_accmodule_to_M2: coverpoint tb.accmodule {
        bins idle_to_M2 = (2'b00 => 2'b10);
        bins M1_to_M2 = (2'b01 => 2'b10);
        bins M3_to_M2 = (2'b11 => 2'b10);
    }
    cp_immidiate_change: cross cp_clk, cp_accmodule_to_M2 {
        bins proper_change_to_M2 = binsof(cp_clk.pos_clk) && binsof(cp_accmodule_to_M2);
        illegal_bins improper_change_to_M2 = binsof(cp_clk.neg_clk) && binsof(cp_accmodule_to_M2);
    }
endgroup
covergroup cg_req_M3_acted_on_edge @(posedge tb.req[2], posedge tb.accmodule[1] or negedge tb.accmodule[0]);
    cp_clk: coverpoint tb.clk {
        bins pos_clk = {1};
        bins neg_clk = {0};
    }
    cp_accmodule_to_M3: coverpoint tb.accmodule {
        bins idle_to_M3 = (2'b00 => 2'b11);
        bins M1_to_M3 = (2'b01 => 2'b11);
        bins M2_to_M3 = (2'b10 => 2'b11);
    }
    cp_immidiate_change: cross cp_clk, cp_accmodule_to_M3 {
        bins proper_change_to_M3 = binsof(cp_clk.pos_clk) && binsof(cp_accmodule_to_M3);
        illegal_bins improper_change_to_M3 = binsof(cp_clk.neg_clk) && binsof(cp_accmodule_to_M3);
    }
endgroup

//Spec. 10
covergroup cg_M2_and_M3_no_it @(posedge tb.clk);
    cp_mstate: coverpoint tb.mstate {
        wildcard bins mstate_any = {5'b?????};
        wildcard ignore_bins M2_in_sec_cycle = {5'b0111?};
        wildcard ignore_bins M3_in_sec_cycle = {5'b1000?};
    }
    cp_done: coverpoint tb.done {
        wildcard bins done_any = {3'b???};
        ignore_bins done_M1 = {3'b001};
        ignore_bins done_M2 = {3'b010};
        ignore_bins done_M3 = {3'b100};
    }
    cp_accmodule: coverpoint tb.accmodule {
        bins M2_to_M3 = (2'b10 => 2'b11);
        bins M3_to_M2 = (2'b11 => 2'b10);
        bins M1_to_M2 = (2'b01 => 2'b10);
        bins M1_to_M3 = (2'b01 => 2'b11);
    }
    cp_both: cross cp_mstate, cp_done, cp_accmodule {
        option.cross_auto_bin_max = 0;
        
        illegal_bins improper_M2_to_M3 = binsof(cp_accmodule.M2_to_M3) && binsof(cp_mstate) && binsof(cp_done);
        illegal_bins improper_M3_to_M2 = binsof(cp_accmodule.M3_to_M2) && binsof(cp_mstate) && binsof(cp_done);
        illegal_bins improper_M1_to_M2 = binsof(cp_accmodule.M1_to_M2) && binsof(cp_mstate) && binsof(cp_done);
        illegal_bins improper_M1_to_M3 = binsof(cp_accmodule.M1_to_M3) && binsof(cp_mstate) && binsof(cp_done);
    }
endgroup

//Spec. 12
covergroup cg_M2_M3_tie_breaker @(posedge tb.clk);
    cp_req: coverpoint tb.req {
        wildcard bins tie = (3'b110 => 3'b???);
    }
    cp_mstate: coverpoint tb.mstate {
        wildcard bins got_to_M3in_2p = (5'b????? => 5'b00110);
        wildcard bins got_to_M2in_3p = (5'b????? => 5'b00101);
    }
    cp_both: cross cp_req, cp_mstate;
endgroup

//Spec. 13
covergroup cg_m2m3_at_most_keep_two_cycles @(posedge tb.clk);
    cp_req: coverpoint tb.iDUT.req {
        wildcard bins req_M2_or_M3 = { 3'b??0 };
    }
    cp_done: coverpoint tb.iDUT.done {
        wildcard bins done_M2 = (3'b?0? => 3'b?0? => 3'b?0?);
        wildcard bins done_M3 = (3'b0?? => 3'b0?? => 3'b0??);
    }
    cp_transitions: coverpoint tb.iDUT.accmodule {
        wildcard bins m2_cutoff = (2'b10 => 2'b10 => 2'b0?);
        wildcard bins m3_cutoff = (2'b11 => 2'b11 => 2'b0?);
        illegal_bins m2_elapsed = (2'b10 => 2'b10 => 2'b10);
        illegal_bins m3_elapsed = (2'b11 => 2'b11 => 2'b11);
    }
    cp_both: cross cp_req, cp_done, cp_transitions;
endgroup

//Spec. 17
covergroup cg_all_modules_doneable @(posedge tb.clk);
    cp_done: coverpoint tb.done {
        wildcard bins done_M1 = {3'b??1};
        wildcard bins done_M2 = {3'b?1?};
        wildcard bins done_M3 = {3'b1??};
    }
    cp_accmodule: coverpoint tb.accmodule {
        bins M1_to_idle = (2'b01 => 2'b00);
        bins M2_to_idle = (2'b10 => 2'b00);
        bins M3_to_idle = (2'b11 => 2'b00);
    }
    cp_both: cross cp_done, cp_accmodule {
        // option.cross_auto_bin_max = 0;

        // bins M1_done_acted_on = binsof(cp_done.done_M1) && binsof(cp_accmodule.M1_to_idle);
        // bins M2_done_acted_on = binsof(cp_done.done_M2) && binsof(cp_accmodule.M2_to_idle);
        // bins M3_done_acted_on = binsof(cp_done.done_M3) && binsof(cp_accmodule.M3_to_idle);
    }
endgroup

// Spec. 18
covergroup cg_cut_off_m2m3_after_2_cycle @(posedge tb.clk);
    cp_req: coverpoint tb.iDUT.req {
        wildcard bins req_M2 = { 3'b?0? };
        wildcard bins req_M3 = { 3'b0?? };
    }
    cp_done: coverpoint tb.iDUT.done {
        wildcard bins done_M2 = (3'b?0? => 3'b?0? => 3'b?0?);
        wildcard bins done_M3 = (3'b0?? => 3'b0?? => 3'b0??);
    }
    cp_transitions: coverpoint tb.iDUT.accmodule {
        bins m2_cutoff = (2'b10 => 2'b10 => 2'b00);
        bins m3_cutoff = (2'b11 => 2'b11 => 2'b00);
        illegal_bins m2_elapsed = (2'b10 => 2'b10 => 2'b10);
        illegal_bins m3_elapsed = (2'b11 => 2'b11 => 2'b11);
    }
    cp_both: cross cp_req, cp_done, cp_transitions;
endgroup

// Spec. 21-4
covergroup cg_nb_interrupts @(posedge tb.clk);
    cp_transitions: coverpoint tb.iDUT.accmodule {
        bins m1_in_m2 = (2'b10 => 2'b01);
        bins m1_in_m3 = (2'b11 => 2'b01);
    }
    cp_nb_interrupts: coverpoint tb.iDUT.nb_interrupts {
        bins interruptions = {[1:2^32]};
    }
    cp_both: cross cp_transitions, cp_nb_interrupts;
endgroup
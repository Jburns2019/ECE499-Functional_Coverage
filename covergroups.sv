//Spec. 4
covergroup cg_reset @(posedge tb.reset);
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
covergroup cg_M1_interrupts @(posedge tb.clk);
    cp_req: coverpoint tb.req {
        wildcard bins req_M1 = {3'b??1};
    }
    cp_accmodule: coverpoint tb.accmodule {
        bins M2_to_M1 = (2'b10 => 2'b01);
        bins M3_to_M1 = (2'b11 => 2'b01);
    }
    cp_both: cross cp_req, cp_accmodule;
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
    }
endgroup

//Spec. 17
covergroup cg_all_modules_doneable @(posedge tb.clk);
    cp_done: coverpoint tb.done {
        wildcard bins done_M1 = {3'b??1};
        wildcard bins done_M2 = {3'b?1?};
        wildcard bins done_M3 = {3'b1??};
    }
    cp_accmodule: coverpoint tb.accmodule {
        bins M1_to_idle = (2'b01 => '0);
        bins M2_to_idle = (2'b10 => '0);
        bins M3_to_idle = (2'b11 => '0);
    }
    cp_both: cross cp_done, cp_accmodule {
        option.cross_auto_bin_max = 0;

        bins M1_done_acted_on = binsof(cp_done.done_M1) && binsof(cp_accmodule.M1_to_idle);
        bins M2_done_acted_on = binsof(cp_done.done_M2) && binsof(cp_accmodule.M2_to_idle);
        bins M3_done_acted_on = binsof(cp_done.done_M3) && binsof(cp_accmodule.M3_to_idle);
    }
endgroup

// Spec. 18
covergroup cg_cut_off_m2m3_after_2_cycle @(posedge tb.clk);
    cp_accmodule: coverpoint tb.iDUT.done {
        wildcard bins done_M2 = (3'b?0? => 3'b?0? => 3'b?0?);
        wildcard bins done_M3 = (3'b0?? => 3'b0?? => 3'b0??);
    }
    cp_transitions: coverpoint tb.iDUT.accmodule {
        illegal_bins m2_elapsed = (2'b10 => 2'b10 => 2'b10);
        illegal_bins m3_elapsed = (2'b11 => 2'b11 => 2'b11);
    }
    cp_both: cross cp_accmodule, cp_transitions {
        option.cross_auto_bin_max = 0;
    }
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
    // cp_both: cross cp_transitions, cp_nb_interrupts;
endgroup

covergroup cg_accmodule_only_assert_at_posedge @(posedge tb.clk, posedge tb.req);
    cp_req: coverpoint tb.req {
        wildcard bins req = {3'b??1};
    }
    cp_accmodule: coverpoint tb.accmodule {
        bins idle_to_M1 = ('0 => 2'b01);
    }
    cp_both: cross cp_req, cp_accmodule;
endgroup
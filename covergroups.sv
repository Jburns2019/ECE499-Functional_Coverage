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

covergroup cg_all_modules_requestable @(posedge tb.clk);
    cp_req_1: coverpoint tb.req {
        wildcard bins req_M1 = {3'b??1};
    }
    cp_accmodule_1: coverpoint tb.accmodule {
        wildcard bins to_M1 = (2'b?? => 2'b01);
    }
    cp_both_1: cross cp_req_1, cp_accmodule_1;

    cp_req_2: coverpoint tb.req {
        wildcard bins req_M2 = {3'b?1?};
    }
    cp_accmodule_2: coverpoint tb.accmodule {
        wildcard bins to_M2 = (2'b?? => 2'b10);
    }
    cp_both_2: cross cp_req_2, cp_accmodule_2;

    cp_req_3: coverpoint tb.req {
        wildcard bins req_M3 = {3'b1??};
    }
    cp_accmodule_3: coverpoint tb.accmodule {
        wildcard bins to_M3= (2'b?? => 2'b11);
    }
    cp_both_3: cross cp_req_3, cp_accmodule_3;
endgroup

// Spec. 18 If no done signal is asserted for a module. Controller will cut off M2 and M3 if 2 cycles elapsed without a done signal.
covergroup cg_cut_off_m2m3_after_2_cycle @(posedge tb.clk);
    cp_accmodule: coverpoint tb.iDUT.done {
        wildcard bins done_M2 = {3'b?0?};
        wildcard bins done_M3 = {3'b0??};
    }
    cp_transitions: coverpoint tb.iDUT.accmodule {
        illegal_bins m2_elapsed = (2'b10 => 2'b10 => 2'b10);
        illegal_bins m3_elapsed = (2'b11 => 2'b11 => 2'b11);
    }
    cp_both: cross cp_accmodule, cp_transitions;
    // cp_both: cross cp_accmodule, cp_transitions {
    //     option.cross_auto_bin_max = 0;
    //     illegal_bins limit_violation_m2 = binsof(cp_accmodule.done_M2) && binsof(cp_transitions.m2_elapsed);
    //     illegal_bins limit_violation_m3 = binsof(cp_accmodule.done_M3) && binsof(cp_transitions.m3_elapsed);
    // }
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
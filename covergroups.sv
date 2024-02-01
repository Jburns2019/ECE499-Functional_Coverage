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

// Spec. 19
covergroup cg_not_remember_last_req @(posedge tb.clk);
    cp_transitions: coverpoint tb.iDUT.req {
        bins m1_in_m2 = (2'b10 => 2'b01);
        bins m1_in_m3 = (2'b11 => 2'b01);
    }
    cp_nb_interrupts: coverpoint tb.iDUT.nb_interrupts {
        bins interruptions = {[1:2^32]};
    }
    // cp_both: cross cp_transitions, cp_nb_interrupts;
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
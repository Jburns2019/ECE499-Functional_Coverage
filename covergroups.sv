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

    cp_req_2: coverpoint tb.req {
        wildcard bins req_M2 = {3'b?1?};
    }
    cp_accmodule_2: coverpoint tb.accmodule {
        wildcard bins to_M2 = (2'b?? => 2'b10);
    }

    cp_req_3: coverpoint tb.req {
        wildcard bins req_M3 = {3'b1??};
    }
    cp_accmodule_3: coverpoint tb.accmodule {
        wildcard bins to_M3= (2'b?? => 2'b11);
    }
endgroup
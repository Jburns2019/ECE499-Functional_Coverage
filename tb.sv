//`timescale 1ns/1ns
`include "covergroups.sv"

module tb();
  // M3,M2,M1
  parameter M1 = 0;
  parameter M2 = 1;
  parameter M3 = 2;
  
  logic [2:0] req; 
  logic [2:0] done;
  logic clk, reset;  // Input signals to the DUT.

  logic [4:0] mstate;
  logic [1:0] accmodule;
  integer nb_interrupts;

  controller iDUT(.*);

  parameter PERIOD = 20;
  always
    #(PERIOD/2) clk = ~clk;

// cg_reset cgi_reset = new;
// cg_M1_interrupts cgi_M1_interrupts = new;
// cg_all_modules_requestable cgi_all_modules_requestable = new;
// cg_req_for_cycle cgi_req_for_cycle = new;
// cg_req_M1_acted_on_edge cgi_req_M1_acted_on_edge = new;
// cg_req_M2_acted_on_edge cgi_req_M2_acted_on_edge = new;
// cg_req_M3_acted_on_edge cgi_req_M3_acted_on_edge = new;
// cg_all_modules_doneable cgi_all_modules_doneable = new;
cg_cut_off_m2m3_after_2_cycle cgi_cut_off_m2m3_after_2_cycle = new;
// cg_nb_interrupts cgi_nb_interrupts = new;

initial begin
  clk = 0;
  req = 3'b000;
  done = 3'b000;
  
  access_IDLE_2p();
  #PERIOD
  access_IDLE_3p();
  #PERIOD;

  access_M1in_2p();
  #PERIOD;
  access_M1in_3p();
  #PERIOD;
  access_M2in_2p();
  #PERIOD;
  access_M2in_3p();
  #PERIOD;
  access_M3in_2p();
  #PERIOD;
  access_M3in_3p();
  #PERIOD;

  access_M1it_2p();
  #PERIOD;
  access_M1it_3p();
  #PERIOD;

  access_M1id_2p();
  #PERIOD
  access_M1id_3p();
  #PERIOD;
  access_M1sd_2p();
  #PERIOD;
  access_M1sd_3p();
  #PERIOD;
  access_M2sd_2p();
  #PERIOD;
  access_M2sd_3p();
  #PERIOD;
  access_M3sd_2p();
  #PERIOD;
  access_M3sd_3p();
  #PERIOD;

  access_M1in_2p();
  #PERIOD req = 1 << M1;
  #PERIOD req = '0;
  #(3*PERIOD);

  access_M1in_2p();
  #PERIOD req = '0;
  #(3*PERIOD);

  access_M2in_2p();
  #PERIOD req = 1 << M1;
  #PERIOD req = '0;
  #(3*PERIOD);

  access_M3in_2p();
  #PERIOD req = 1 << M1;
  #PERIOD req = '0;
  #(3*PERIOD);

  for (int n = 2; n < 4; n++) begin
    all_IDLE_np(n);
    all_M1in_np(n);
    all_M2in_np(n);
    all_M3in_np(n);
    all_M1it_np(n);
    all_M1id_np(n);
    all_M1sd_np(n);
    all_M2sd_np(n);
    all_M3sd_np(n);
  end
  
  # 20 $dumpflush;
  $stop;
end

initial begin
  $dumpfile("test.vcd");
  $dumpvars(1, tb);
end

task request_reset_controller();
  reset = 1;
  req = '0;
  done = '0;
  #PERIOD reset = 0;
endtask

//Idle.
task access_IDLE_2p();
  request_reset_controller();
endtask

task access_IDLE_3p();
  access_M2in_3p();
  #PERIOD done = 1 << M2;
  req = '0;
endtask


//M1 first cycle.
task access_M1in_2p();
  request_reset_controller();
  req = 1 << M1;
endtask

task access_M1in_3p();
  access_M2in_3p();
  #PERIOD done = 1 << M2;
  req = 1 << M1;
endtask


//M2 first cycle.
task access_M2in_2p();
  request_reset_controller();
  req = 1 << M2;
endtask

task access_M2in_3p();
  request_reset_controller();
  req = 1 << M3 | 1 << M2;
endtask


//M3 first cycle.
task access_M3in_2p();
  request_reset_controller();
  req = 1 << M3;
endtask

task access_M3in_3p();
  access_M2in_3p();
  #PERIOD done = 1 << M2;
  req = 1 << M3;
endtask


//Interupts.
task access_M1it_2p();
  access_M2in_2p();
  #PERIOD req = 1 << M1;
endtask

task access_M1it_3p();
  access_M2in_3p();
  #PERIOD req = 1 << M1;
endtask


//M1 indefinite.
task access_M1id_2p();
  access_M1in_2p();
  #PERIOD req = '0;
  done = '0;
endtask

task access_M1id_3p();
  access_M1in_3p();
  #PERIOD req = '0;
  done = '0;
endtask


//M1 2nd cycles.
task access_M1sd_2p();
  access_M1it_2p();
  #PERIOD req = '0;
  done = '0;
endtask

task access_M1sd_3p();
  access_M1it_3p();
  #PERIOD req = '0;
  done = '0;
endtask


//M2 2nd cycles.
task access_M2sd_2p();
  access_M2in_2p();
  #PERIOD req = '0;
  done = '0;
endtask

task access_M2sd_3p();
  access_M2in_3p();
  #PERIOD req = '0;
  done = '0;
endtask


//M3 2nd cycles.
task access_M3sd_2p();
  access_M3in_2p();
  #PERIOD req = '0;
  done = '0;
endtask

task access_M3sd_3p();
  access_M3in_3p();
  #PERIOD req = '0;
  done = '0;
endtask

task all_IDLE_np(int n);
  for (int i= 0; i < 8; i++) begin
    if (n == 2) access_IDLE_2p();
    else access_IDLE_3p();
    #PERIOD req = i;
    #PERIOD;
  end
endtask

task all_M1in_np(int n);
  for (int i= 0; i < 2; i++) begin
    if (n == 2) access_M1in_2p();
    else access_M1in_3p();
    #PERIOD done = i;
    #PERIOD;
  end
endtask

task all_M2in_np(int n);
  for (int i = 0; i < 8; i++) begin
    if (n == 2) access_M2in_2p();
    else access_M2in_3p();
    #PERIOD done = 1 << M2;
    req = i;
    #PERIOD;
  end

  if (n == 2) access_M2in_2p();
  else access_M2in_3p();
  #PERIOD req = 1 << M1;
  #PERIOD;
endtask

task all_M3in_np(int n);
  for (int i = 0; i < 8; i++) begin
    if (n == 2) access_M3in_2p();
    else access_M3in_3p();
    #PERIOD done = 1 << M3;
    req = i;
    #PERIOD;
  end

  if (n == 2) access_M3in_2p();
  else access_M3in_3p();
  #PERIOD req = 1 << M1;
  #PERIOD;
endtask

task all_M1it_np(int n);
  for (int i = 0; i < 8; i++) begin
    if (n == 2) access_M1it_2p();
    else access_M1it_3p();
    #PERIOD done = 1 << M1;
    req = i;
    #PERIOD;
  end
endtask

task all_M1id_np(int n);
  for (int i = 0; i < 8; i++) begin
    if (n == 2) access_M1id_2p();
    else access_M1id_3p();
    #PERIOD done = 1 << M1;
    req = i;
    #PERIOD;
  end

  if (n == 2) access_M1id_2p();
  else access_M1id_3p();
  #PERIOD;
endtask

task all_M1sd_np(int n);
  for (int i = 0; i < 8; i++) begin
    if (n == 2) access_M1sd_2p();
    else access_M1sd_3p();
    #PERIOD req = i;
    #PERIOD;
  end
endtask

task all_M2sd_np(int n);
  for (int i = 0; i < 8; i++) begin
    if (n == 2) access_M2sd_2p();
    else access_M2sd_3p();
    #PERIOD req = i;
    #PERIOD;
  end
endtask

task all_M3sd_np(int n);
  for (int i = 0; i < 8; i++) begin
    if (n == 2) access_M3sd_2p();
    else access_M3sd_3p();
    #PERIOD req = i;
    #PERIOD;
  end
endtask
endmodule
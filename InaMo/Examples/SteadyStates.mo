within InaMo.Examples;
model SteadyStates "calculates steady states at different voltages"
  // used to determine whether starting values in C++/CellML correlate to steady states
  // NOTE: I_na, I_Ca,L - seems like slow inactivation is not at steady state, but rest is
  // NOTE: I_to - only act is at steady state
  // NOTE: I_K,r - only inact is at steady state

  // f_tc, f_cmi - are in steady state (step_an_ca_cyto)
  // f_cms - is in steady state (step_an_ca_sub)
  // f_csl - is not in steady state, but virtually does not change (step_an_ca_sub)
  // f_cq - is in steady state (step_an_ca_jsr)
  // f_tmc, f_tmm - is not in steady state (but close)
  import InaMo.Components.ExperimentalMethods.VoltageClamp;
  function buffSteady "calculates steady state of buffer fraction"
    input Real k;
    input Real kb;
    input Real c;
    output Real f;
  algorithm
    // found by manually solving buffer formula for der(f) = 0
    f := 1 / (kb / (k * c) + 1);
  end buffSteady;
  function buffSteady2 "calculates steady state of buffer fraction for buffer that can bind to two ions"
    input Real k;
    input Real kb;
    input Real c;
    input Real k2;
    input Real kb2;
    input Real c2;
    output Real f;
    output Real f2;
  algorithm
    // found by manually solving buffer formula for der(f) = 0
    f := k * c * kb2 / (k * c * kb2 + kb * k2 * c2 + kb * kb2);
    f2 := kb * k2 * c2 / (kb * k2 * c2 + k * c * kb2 + kb * kb2);
  end buffSteady2;
  model BuffSteady2 "simplified version of buffSteady2 that leaves work to solver"
    parameter Real k;
    parameter Real kb;
    parameter Real k2;
    parameter Real kb2;
    parameter Real c2;
    input Real c;
    output Real f;
    output Real f2;
  equation
    0 = k * c * (1 - f - f2) - kb * f;
    0 = k2 * c2 * (1 - f2 - f) - kb2 * f2;
  end BuffSteady2;
  VoltageClamp vc(v_stim = v);
  ANCell an(l2.use_init=false);
  NCell n(l2.use_init=false);
  NHCell nh(l2.use_init=false);
  SI.Voltage v(start=-0.1, fixed=true);
  SI.Concentration ca(start=1e-5, fixed=true);
  parameter SI.Voltage init_an_v = -7.00E-02;
  parameter SI.Voltage init_n_v = -6.21E-02;
  parameter SI.Voltage init_nh_v = -6.86E-02;
  parameter Real init_an_na_act = 0.01227;
  parameter Real init_an_na_inact_fast = 0.717;
  parameter Real init_an_na_inact_slow = 0.6162;
  parameter Real init_an_cal_act = 4.07E-05;
  parameter Real init_an_cal_inact_fast = 0.9985;
  parameter Real init_an_cal_inact_slow = 0.9875;
  parameter Real init_an_to_act = 8.86E-03;
  parameter Real init_an_to_inact_fast = 0.8734;
  parameter Real init_an_to_inact_slow = 0.1503;
  parameter Real init_an_kr_act_fast = 0.07107;
  parameter Real init_an_kr_act_slow = 0.0484;
  parameter Real init_an_kr_inact = 0.9866;

  Real an_na_act = an.na.act.falpha(v) / (an.na.act.falpha(v) + an.na.act.fbeta(v)) - init_an_na_act;
  Real an_na_inact_fast = an.na.inact_fast.fsteady(v) - init_an_na_inact_fast;
  Real an_na_inact_slow = an.na.inact_slow.fsteady(v) - init_an_na_inact_slow;
  Real an_cal_act = an.cal.act.fsteady(v) - init_an_cal_act;
  Real an_cal_inact_fast = an.cal.inact_fast.fsteady(v) - init_an_cal_inact_fast;
  Real an_cal_inact_slow = an.cal.inact_slow.fsteady(v) - init_an_cal_inact_slow;
  Real an_to_act = an.to.act.fsteady(v) - init_an_to_act;
  Real an_to_inact_fast = an.to.inact_fast.fsteady(v) - init_an_to_inact_fast;
  Real an_to_inact_slow = an.to.inact_slow.fsteady(v) - init_an_to_inact_slow;
  //Real an_kr_act_fast2 = an.kr.act_fast.ftau.falpha(v) / (an.kr.act_fast.ftau.falpha(v) + an.kr.act_fast.ftau.fbeta(v)) - init_an_kr_act_fast;
  Real an_kr_act_fast = an.kr.act_fast.fsteady(v) - init_an_kr_act_fast;
  Real an_kr_act_slow = an.kr.act_slow.fsteady(v) - init_an_kr_act_slow;
  Real an_kr_inact = an.kr.inact.fsteady(v) - init_an_kr_inact;

  Boolean step_an_v = v > init_an_v;
  Boolean step_n_v = v > init_n_v;
  Boolean step_nh_v = v > init_nh_v;

  parameter SI.Concentration init_an_ca_cyto = 1.21E-04;
  parameter SI.Concentration init_an_ca_sub = 6.40E-05;
  parameter SI.Concentration init_an_ca_jsr = 0.4273;
  parameter SI.Concentration init_an_ca_nsr = 1.068;
  parameter Real init_an_ca_f_tc = 0.02359;
  parameter Real init_an_ca_f_cmi = 0.04845;
  parameter Real init_an_ca_f_cms = 0.02626;
  parameter Real init_an_ca_f_cq = 0.3379;
  parameter Real init_an_ca_f_csl = 3.94E-05;
  parameter Real init_an_ca_f_tmc = 0.3667;
  parameter Real init_an_ca_f_tmm = 0.5594;

  Real an_ca_f_tc = buffSteady(an.ca.tc.k, an.ca.tc.kb, ca) - init_an_ca_f_tc;
  Real an_ca_f_cmi = buffSteady(an.ca.cm_cyto.k, an.ca.cm_cyto.kb, ca) - init_an_ca_f_cmi;
  Real an_ca_f_cms = buffSteady(an.ca.cm_sub.k, an.ca.cm_sub.kb, ca) - init_an_ca_f_cms;
  Real an_ca_f_cq = buffSteady(an.ca.cq.k, an.ca.cq.kb, ca) - init_an_ca_f_cq;
  Real an_ca_f_csl = buffSteady(an.ca.cm_sl.k, an.ca.cm_sl.kb, ca) - init_an_ca_f_csl;
  BuffSteady2 tm(
    k = an.ca.tmc.k,
    kb = an.ca.tmc.kb,
    k2 = an.ca.tmm.k,
    kb2 = an.ca.tmm.kb,
    c2 = an.ca.mg.c_const,
    c = ca
  );
  Real temp_f;
  Real temp_f2;
  Real an_ca_f_tmc = tm.f - init_an_ca_f_tmc;
  Real an_ca_f_tmm = tm.f2 - init_an_ca_f_tmm;
  Real an_ca_f_tmc2 = temp_f - init_an_ca_f_tmc;
  Real an_ca_f_tmm2 = temp_f2 - init_an_ca_f_tmm;

  Boolean step_an_ca_cyto = ca > init_an_ca_cyto;
  Boolean step_an_ca_sub = ca > init_an_ca_sub;
  Boolean step_an_ca_jsr = ca > init_an_ca_jsr;
  Boolean step_an_ca_nsr = ca > init_an_ca_nsr;
equation
  (temp_f, temp_f2) = buffSteady2(an.ca.tmc.k, an.ca.tmc.kb, ca, an.ca.tmm.k, an.ca.tmm.kb, an.ca.mg.c_const);
  connect(an.p, vc.p);
  connect(an.n, vc.n);
  connect(n.p, vc.p);
  connect(n.n, vc.n);
  connect(nh.p, vc.p);
  connect(nh.n, vc.n);
  der(v) = 0.2;
  der(ca) = 1e-3;
end SteadyStates;

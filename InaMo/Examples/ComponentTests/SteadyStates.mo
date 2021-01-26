within InaMo.Examples;
model SteadyStates "calculates steady states at different voltages"
  // used to determine whether starting values in C++/CellML correlate to steady states
  // Results can be found in notes/InadaCompareEquationsAndParameters.ods
  // (blue text = steady state, red text = not steady state)
  import InaMo.ExperimentalMethods.VoltageClamp.VoltageClamp;
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
  VoltageClamp vc_an(v_stim = init_an_v);
  VoltageClamp vc_n(v_stim = init_n_v);
  VoltageClamp vc_nh(v_stim = init_nh_v);
  // NOTE currently the initial values are not forwarded to the cell models
  // should we do that or is it unnecessary?
  ANCell an(
    l2.use_init=false,
    ca.cyto.c_start=init_an_ca_cyto,
    ca.sub.c_start=init_an_ca_sub,
    ca.jsr.c_start=init_an_ca_jsr,
    ca.nsr.c_start=init_an_ca_nsr,
    ca.cq.k = param_all_ca_cq_k,
    ca.tmc.k = param_all_ca_tmc_k
  );
  NCell n(
    l2.use_init=false,
    ca.cyto.c_start=init_n_ca_cyto,
    ca.sub.c_start=init_n_ca_sub,
    ca.jsr.c_start=init_n_ca_jsr,
    ca.nsr.c_start=init_n_ca_nsr,
    ca.cq.k = param_all_ca_cq_k,
    ca.tmc.k = param_all_ca_tmc_k
  );
  NHCell nh(
    l2.use_init=false,
    ca.cyto.c_start=init_nh_ca_cyto,
    ca.sub.c_start=init_nh_ca_sub,
    ca.jsr.c_start=init_nh_ca_jsr,
    ca.nsr.c_start=init_nh_ca_nsr,
    ca.cq.k = param_all_ca_cq_k,
    ca.tmc.k = param_all_ca_tmc_k
  );
  SI.Voltage v(start=-0.1, fixed=true);
  SI.Concentration ca_low(start=0, fixed=true);
  SI.Concentration ca_high(start=0, fixed=true);

  parameter SI.Voltage init_an_v = -0.070030;
  parameter SI.Voltage init_n_v = -6.213E-02;
  parameter SI.Voltage init_nh_v = -6.86300E-02;

  // some relevant parameters differ between model versions
  parameter Real param_all_ca_cq_k = 534;
  parameter Real param_all_ca_tmc_k = 227700;

  Boolean step_an_v = v > init_an_v;
  Boolean step_n_v = v > init_n_v;
  Boolean step_nh_v = v > init_nh_v;

  ////// Tests for buffSteady and BuffSteady2 //////

  parameter SI.Volume v_cyto = 1;
  ConstantConcentration sim_buff_ca_cyto(c_const=init_an_ca_cyto, vol=v_cyto);
  Buffer sim_buff_tc(n_tot=an.ca.tc.n_tot, f_start=init_an_ca_f_tc, k=an.ca.tc.k, kb=an.ca.tc.kb);
  ConstantConcentration sim_buff_mg(c_const=an.ca.mg.c_const, vol=v_cyto);
  Buffer2 sim_buff_tmc(n_tot=an.ca.tmc.n_tot, f_start=init_an_ca_f_tmc, k=an.ca.tmc.k, kb=an.ca.tmc.kb);
  Buffer2 sim_buff_tmm(n_tot=an.ca.tmm.n_tot, f_start=init_an_ca_f_tmm, k=an.ca.tmm.k, kb=an.ca.tmm.kb);

  BuffSteady2 sim_buff_tm_steady(
    k = sim_buff_tmc.k,
    kb = sim_buff_tmc.kb,
    k2 = sim_buff_tmm.k,
    kb2 = sim_buff_tmm.kb,
    c2 = sim_buff_mg.c_const,
    c = sim_buff_ca_cyto.c_const
  );

  Real sim_buff_f_tc = buffSteady(an.ca.tc.k, an.ca.tc.kb, init_an_ca_cyto) - sim_buff_tc.f;
  Real sim_buff_f_tmc = sim_buff_tm_steady.f - sim_buff_tmc.f;
  Real sim_buff_f_tmm = sim_buff_tm_steady.f2 - sim_buff_tmm.f;

  ///////// AN cell //////////////

  parameter Real init_an_na_act = 0.01227;
  parameter Real init_an_na_inact_fast = 0.717;
  parameter Real init_an_na_inact_slow = 0.6162;
  parameter Real init_an_cal_act = 4.07E-05;
  parameter Real init_an_cal_inact_fast = 0.9985;
  parameter Real init_an_cal_inact_slow = 0.9875;
  parameter Real init_an_to_act = 0.008857;
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
  Real an_kr_act_fast = an.kr.act_fast.fsteady(v) - init_an_kr_act_fast;
  Real an_kr_act_slow = an.kr.act_slow.fsteady(v) - init_an_kr_act_slow;
  Real an_kr_inact = an.kr.inact.fsteady(v) - init_an_kr_inact;

  parameter Real steady_an_na_act = an.na.act.falpha(init_an_v) / (an.na.act.falpha(init_an_v) + an.na.act.fbeta(init_an_v));
  parameter Real steady_an_na_inact_fast = an.na.inact_fast.fsteady(init_an_v);
  parameter Real steady_an_na_inact_slow = an.na.inact_slow.fsteady(init_an_v);
  parameter Real steady_an_cal_act = an.cal.act.fsteady(init_an_v);
  parameter Real steady_an_cal_inact_fast = an.cal.inact_fast.fsteady(init_an_v);
  parameter Real steady_an_cal_inact_slow = an.cal.inact_slow.fsteady(init_an_v);
  parameter Real steady_an_to_act = an.to.act.fsteady(init_an_v);
  parameter Real steady_an_to_inact_fast = an.to.inact_fast.fsteady(init_an_v);
  parameter Real steady_an_to_inact_slow = an.to.inact_slow.fsteady(init_an_v);
  parameter Real steady_an_kr_act_fast = an.kr.act_fast.fsteady(init_an_v);
  parameter Real steady_an_kr_act_slow = an.kr.act_slow.fsteady(init_an_v);
  parameter Real steady_an_kr_inact = an.kr.inact.fsteady(init_an_v);

  Real sim_an_na_act = an.na.act.falpha(vc_an.v) / (an.na.act.falpha(vc_an.v) + an.na.act.fbeta(vc_an.v)) - an.na.act.n;
  Real sim_an_na_inact_fast = an.na.inact_fast.fsteady(vc_an.v) - an.na.inact_fast.n;
  Real sim_an_na_inact_slow = an.na.inact_slow.fsteady(vc_an.v) - an.na.inact_slow.n;
  Real sim_an_cal_act = an.cal.act.fsteady(vc_an.v) - an.cal.act.n;
  Real sim_an_cal_inact_fast = an.cal.inact_fast.fsteady(vc_an.v) - an.cal.inact_fast.n;
  Real sim_an_cal_inact_slow = an.cal.inact_slow.fsteady(vc_an.v) - an.cal.inact_slow.n;
  Real sim_an_to_act = an.to.act.fsteady(vc_an.v) - an.to.act.n;
  Real sim_an_to_inact_fast = an.to.inact_fast.fsteady(vc_an.v) - an.to.inact_fast.n;
  Real sim_an_to_inact_slow = an.to.inact_slow.fsteady(vc_an.v) - an.to.inact_slow.n;
  Real sim_an_kr_act_fast = an.kr.act_fast.fsteady(vc_an.v) - an.kr.act_fast.n;
  Real sim_an_kr_act_slow = an.kr.act_slow.fsteady(vc_an.v) - an.kr.act_slow.n;
  Real sim_an_kr_inact = an.kr.inact.fsteady(vc_an.v) - an.kr.inact.n;

  parameter SI.Concentration init_an_ca_cyto = 1.2060E-04;
  parameter SI.Concentration init_an_ca_sub = 6.3970E-05;
  parameter SI.Concentration init_an_ca_jsr = 0.4273;
  parameter SI.Concentration init_an_ca_nsr = 1.068;
  parameter Real init_an_ca_f_tc = 0.02359;
  parameter Real init_an_ca_f_cmi = 0.04845;
  parameter Real init_an_ca_f_cms = 0.02626;
  parameter Real init_an_ca_f_cq = 0.3379;
  parameter Real init_an_ca_f_csl = 3.936E-05;
  parameter Real init_an_ca_f_tmc = 0.3667;
  parameter Real init_an_ca_f_tmm = 0.5594;

  Real an_ca_f_tc = buffSteady(an.ca.tc.k, an.ca.tc.kb, ca_low) - init_an_ca_f_tc;
  Real an_ca_f_cmi = buffSteady(an.ca.cm_cyto.k, an.ca.cm_cyto.kb, ca_low) - init_an_ca_f_cmi;
  Real an_ca_f_cms = buffSteady(an.ca.cm_sub.k, an.ca.cm_sub.kb, ca_low) - init_an_ca_f_cms;
  Real an_ca_f_cq = buffSteady(an.ca.cq.k, an.ca.cq.kb, ca_high) - init_an_ca_f_cq;
  Real an_ca_f_csl = buffSteady(an.ca.cm_sl.k, an.ca.cm_sl.kb, ca_low) - init_an_ca_f_csl;
  BuffSteady2 an_tm(
    k = an.ca.tmc.k,
    kb = an.ca.tmc.kb,
    k2 = an.ca.tmm.k,
    kb2 = an.ca.tmm.kb,
    c2 = an.ca.mg.c_const,
    c = ca_low
  );
  Real temp_f;
  Real temp_f2;
  Real an_ca_f_tmc = an_tm.f - init_an_ca_f_tmc;
  Real an_ca_f_tmm = an_tm.f2 - init_an_ca_f_tmm;
  Real an_ca_f_tmc2 = temp_f - init_an_ca_f_tmc;
  Real an_ca_f_tmm2 = temp_f2 - init_an_ca_f_tmm;

  parameter Real steady_an_ca_f_tc = buffSteady(an.ca.tc.k, an.ca.tc.kb, init_an_ca_cyto);
  parameter Real steady_an_ca_f_cmi = buffSteady(an.ca.cm_cyto.k, an.ca.cm_cyto.kb, init_an_ca_cyto);
  parameter Real steady_an_ca_f_cms = buffSteady(an.ca.cm_sub.k, an.ca.cm_sub.kb, init_an_ca_sub);
  parameter Real steady_an_ca_f_cq = buffSteady(an.ca.cq.k, an.ca.cq.kb, init_an_ca_jsr);
  parameter Real steady_an_ca_f_csl = buffSteady(an.ca.cm_sl.k, an.ca.cm_sl.kb, init_an_ca_sub);
  // NOTE: each expression uses only first return value
  parameter Real steady_an_ca_f_tmc = buffSteady2(an.ca.tmc.k, an.ca.tmc.kb, init_an_ca_cyto, an.ca.tmm.k, an.ca.tmm.kb, an.ca.mg.c_const);
  parameter Real steady_an_ca_f_tmm = buffSteady2(an.ca.tmm.k, an.ca.tmm.kb, an.ca.mg.c_const, an.ca.tmc.k, an.ca.tmc.kb, init_an_ca_cyto);

  Boolean step_an_ca_cyto = ca_low > init_an_ca_cyto;
  Boolean step_an_ca_sub = ca_low > init_an_ca_sub;
  Boolean step_an_ca_jsr = ca_high > init_an_ca_jsr;
  Boolean step_an_ca_nsr = ca_high > init_an_ca_nsr;

  ///////// N cell //////////////

  parameter Real init_n_cal_act = 1.533E-04;
  parameter Real init_n_cal_inact_fast = 0.6861;
  parameter Real init_n_cal_inact_slow = 0.4441;
  parameter Real init_n_kr_act_fast = 0.6067;
  parameter Real init_n_kr_act_slow = 0.1287;
  parameter Real init_n_kr_inact = 0.9775;
  parameter Real init_n_f_act = 0.03825;
  parameter Real init_n_st_act = 0.1933;
  parameter Real init_n_st_inact = 0.4886;

  Real n_cal_act = an.cal.act.fsteady(v) - init_n_cal_act;
  Real n_cal_inact_fast = an.cal.inact_fast.fsteady(v) - init_n_cal_inact_fast;
  Real n_cal_inact_slow = an.cal.inact_slow.fsteady(v) - init_n_cal_inact_slow;
  Real n_kr_act_fast = n.kr.act_fast.fsteady(v) - init_n_kr_act_fast;
  Real n_kr_act_slow = n.kr.act_slow.fsteady(v) - init_n_kr_act_slow;
  Real n_kr_inact = n.kr.inact.fsteady(v) - init_n_kr_inact;
  Real n_f_act = n.hcn.act.fsteady(v) - init_n_f_act;
  Real n_st_act = n.st.act.fsteady(v) - init_n_st_act;
  Real n_st_inact = n.st.inact.falpha(v) / (n.st.inact.falpha(v) + n.st.inact.fbeta(v)) - init_n_st_inact;

  Real steady_n_cal_act = an.cal.act.fsteady(init_n_v);
  Real steady_n_cal_inact_fast = an.cal.inact_fast.fsteady(init_n_v);
  Real steady_n_cal_inact_slow = an.cal.inact_slow.fsteady(init_n_v);
  Real steady_n_kr_act_fast = n.kr.act_fast.fsteady(init_n_v);
  Real steady_n_kr_act_slow = n.kr.act_slow.fsteady(init_n_v);
  Real steady_n_kr_inact = n.kr.inact.fsteady(init_n_v);
  Real steady_n_f_act = n.hcn.act.fsteady(init_n_v);
  Real steady_n_st_act = n.st.act.fsteady(init_n_v);
  Real steady_n_st_inact = n.st.inact.falpha(init_n_v) / (n.st.inact.falpha(init_n_v) + n.st.inact.fbeta(init_n_v));

  Real sim_n_cal_act = an.cal.act.fsteady(vc_n.v) - n.cal.act.n;
  Real sim_n_cal_inact_fast = an.cal.inact_fast.fsteady(vc_n.v) - n.cal.inact_fast.n;
  Real sim_n_cal_inact_slow = an.cal.inact_slow.fsteady(vc_n.v) - n.cal.inact_slow.n;
  Real sim_n_kr_act_fast = n.kr.act_fast.fsteady(vc_n.v) - n.kr.act_fast.n;
  Real sim_n_kr_act_slow = n.kr.act_slow.fsteady(vc_n.v) - n.kr.act_slow.n;
  Real sim_n_kr_inact = n.kr.inact.fsteady(vc_n.v) - n.kr.inact.n;
  Real sim_n_f_act = n.hcn.act.fsteady(vc_n.v) - n.hcn.act.n;
  Real sim_n_st_act = n.st.act.fsteady(vc_n.v) - n.st.act.n;
  Real sim_n_st_inact = n.st.inact.falpha(vc_n.v) / (n.st.inact.falpha(vc_n.v) + n.st.inact.fbeta(vc_n.v)) - n.st.inact.n;

  parameter SI.Concentration init_n_ca_cyto = 3.623E-04;
  parameter SI.Concentration init_n_ca_sub = 2.294E-04;
  parameter SI.Concentration init_n_ca_jsr = 0.08227;
  parameter SI.Concentration init_n_ca_nsr = 1.146;

  parameter Real init_n_ca_f_tc = 0.6838;
  parameter Real init_n_ca_f_tmc = 0.6192;
  parameter Real init_n_ca_f_tmm = 0.3363;
  parameter Real init_n_ca_f_cmi = 0.1336;
  parameter Real init_n_ca_f_cms = 0.08894;
  parameter Real init_n_ca_f_cq = 0.08736;
  parameter Real init_n_ca_f_csl = 4.7640E-05;

  Real n_ca_f_tc = buffSteady(n.ca.tc.k, n.ca.tc.kb, ca_low) - init_n_ca_f_tc;
  Real n_ca_f_cmi = buffSteady(n.ca.cm_cyto.k, n.ca.cm_cyto.kb, ca_low) - init_n_ca_f_cmi;
  Real n_ca_f_cms = buffSteady(n.ca.cm_sub.k, n.ca.cm_sub.kb, ca_low) - init_n_ca_f_cms;
  Real n_ca_f_cq = buffSteady(n.ca.cq.k, n.ca.cq.kb, ca_high) - init_n_ca_f_cq;
  Real n_ca_f_csl = buffSteady(n.ca.cm_sl.k, n.ca.cm_sl.kb, ca_low) - init_n_ca_f_csl;
  BuffSteady2 n_tm(
    k = n.ca.tmc.k,
    kb = n.ca.tmc.kb,
    k2 = n.ca.tmm.k,
    kb2 = n.ca.tmm.kb,
    c2 = n.ca.mg.c_const,
    c = ca_low
  );
  Real n_ca_f_tmc = n_tm.f - init_n_ca_f_tmc;
  Real n_ca_f_tmm = n_tm.f2 - init_n_ca_f_tmm;

  parameter Real steady_n_ca_f_tc = buffSteady(n.ca.tc.k, n.ca.tc.kb, init_n_ca_cyto);
  parameter Real steady_n_ca_f_cmi = buffSteady(n.ca.cm_cyto.k, n.ca.cm_cyto.kb, init_n_ca_cyto);
  parameter Real steady_n_ca_f_cms = buffSteady(n.ca.cm_sub.k, n.ca.cm_sub.kb, init_n_ca_sub);
  parameter Real steady_n_ca_f_cq = buffSteady(n.ca.cq.k, n.ca.cq.kb, init_n_ca_jsr);
  parameter Real steady_n_ca_f_csl = buffSteady(n.ca.cm_sl.k, n.ca.cm_sl.kb, init_n_ca_sub);
  parameter Real steady_n_ca_f_tmc = buffSteady2(n.ca.tmc.k, n.ca.tmc.kb, init_n_ca_cyto, n.ca.tmm.k, n.ca.tmm.kb, n.ca.mg.c_const);
  parameter Real steady_n_ca_f_tmm = buffSteady2(n.ca.tmm.k, n.ca.tmm.kb, n.ca.mg.c_const, n.ca.tmc.k, n.ca.tmc.kb, init_n_ca_cyto);

  Boolean step_n_ca_cyto = ca_low > init_n_ca_cyto;
  Boolean step_n_ca_sub = ca_low > init_n_ca_sub;
  Boolean step_n_ca_jsr = ca_high > init_n_ca_jsr;
  Boolean step_n_ca_nsr = ca_high > init_n_ca_nsr;

  ///////// NH cell //////////////

  parameter Real init_nh_na_act = 0.01529;
  parameter Real init_nh_na_inact_fast = 0.6438;
  parameter Real init_nh_na_inact_slow = 0.5552;
  parameter Real init_nh_cal_act = 5.0250E-05;
  parameter Real init_nh_cal_inact_fast = 0.9981;
  parameter Real init_nh_cal_inact_slow = 0.9831;
  parameter Real init_nh_to_act = 9.581E-03;
  parameter Real init_nh_to_inact_fast = 0.864;
  parameter Real init_nh_to_inact_slow = 0.1297;
  parameter Real init_nh_kr_act_fast = 0.09949;
  parameter Real init_nh_kr_act_slow = 0.07024;
  parameter Real init_nh_kr_inact = 0.9853;

  Real nh_na_act = nh.na.act.falpha(v) / (nh.na.act.falpha(v) + nh.na.act.fbeta(v)) - init_nh_na_act;
  Real nh_na_inact_fast = nh.na.inact_fast.fsteady(v) - init_nh_na_inact_fast;
  Real nh_na_inact_slow = nh.na.inact_slow.fsteady(v) - init_nh_na_inact_slow;
  Real nh_cal_act = nh.cal.act.fsteady(v) - init_nh_cal_act;
  Real nh_cal_inact_fast = nh.cal.inact_fast.fsteady(v) - init_nh_cal_inact_fast;
  Real nh_cal_inact_slow = nh.cal.inact_slow.fsteady(v) - init_nh_cal_inact_slow;
  Real nh_to_act = nh.to.act.fsteady(v) - init_nh_to_act;
  Real nh_to_inact_fast = nh.to.inact_fast.fsteady(v) - init_nh_to_inact_fast;
  Real nh_to_inact_slow = nh.to.inact_slow.fsteady(v) - init_nh_to_inact_slow;
  Real nh_kr_act_fast = nh.kr.act_fast.fsteady(v) - init_nh_kr_act_fast;
  Real nh_kr_act_slow = nh.kr.act_slow.fsteady(v) - init_nh_kr_act_slow;
  Real nh_kr_inact = nh.kr.inact.fsteady(v) - init_nh_kr_inact;

  parameter Real steady_nh_na_act = nh.na.act.falpha(init_nh_v) / (nh.na.act.falpha(init_nh_v) + nh.na.act.fbeta(init_nh_v));
  parameter Real steady_nh_na_inact_fast = nh.na.inact_fast.fsteady(init_nh_v);
  parameter Real steady_nh_na_inact_slow = nh.na.inact_slow.fsteady(init_nh_v);
  parameter Real steady_nh_cal_act = nh.cal.act.fsteady(init_nh_v);
  parameter Real steady_nh_cal_inact_fast = nh.cal.inact_fast.fsteady(init_nh_v);
  parameter Real steady_nh_cal_inact_slow = nh.cal.inact_slow.fsteady(init_nh_v);
  parameter Real steady_nh_to_act = nh.to.act.fsteady(init_nh_v);
  parameter Real steady_nh_to_inact_fast = nh.to.inact_fast.fsteady(init_nh_v);
  parameter Real steady_nh_to_inact_slow = nh.to.inact_slow.fsteady(init_nh_v);
  parameter Real steady_nh_kr_act_fast = nh.kr.act_fast.fsteady(init_nh_v);
  parameter Real steady_nh_kr_act_slow = nh.kr.act_slow.fsteady(init_nh_v);
  parameter Real steady_nh_kr_inact = nh.kr.inact.fsteady(init_nh_v);

  Real sim_nh_na_act = nh.na.act.falpha(vc_nh.v) / (nh.na.act.falpha(vc_nh.v) + nh.na.act.fbeta(vc_nh.v)) - nh.na.act.n;
  Real sim_nh_na_inact_fast = nh.na.inact_fast.fsteady(vc_nh.v) - nh.na.inact_fast.n;
  Real sim_nh_na_inact_slow = nh.na.inact_slow.fsteady(vc_nh.v) - nh.na.inact_slow.n;
  Real sim_nh_cal_act = nh.cal.act.fsteady(vc_nh.v) - nh.cal.act.n;
  Real sim_nh_cal_inact_fast = nh.cal.inact_fast.fsteady(vc_nh.v) - nh.cal.inact_fast.n;
  Real sim_nh_cal_inact_slow = nh.cal.inact_slow.fsteady(vc_nh.v) - nh.cal.inact_slow.n;
  Real sim_nh_to_act = nh.to.act.fsteady(vc_nh.v) - nh.to.act.n;
  Real sim_nh_to_inact_fast = nh.to.inact_fast.fsteady(vc_nh.v) - nh.to.inact_fast.n;
  Real sim_nh_to_inact_slow = nh.to.inact_slow.fsteady(vc_nh.v) - nh.to.inact_slow.n;
  Real sim_nh_kr_act_fast = nh.kr.act_fast.fsteady(vc_nh.v) - nh.kr.act_fast.n;
  Real sim_nh_kr_act_slow = nh.kr.act_slow.fsteady(vc_nh.v) - nh.kr.act_slow.n;
  Real sim_nh_kr_inact = nh.kr.inact.fsteady(vc_nh.v) - nh.kr.inact.n;

  parameter SI.Concentration init_nh_ca_cyto = 1.38600E-04;
  parameter SI.Concentration init_nh_ca_sub = 7.31400E-05;
  parameter SI.Concentration init_nh_ca_jsr = 0.4438;
  parameter SI.Concentration init_nh_ca_nsr = 1.187;
  parameter Real init_nh_ca_f_tc = 0.02703;
  parameter Real init_nh_ca_f_tmc = 0.402;
  parameter Real init_nh_ca_f_tmm = 0.5282;
  parameter Real init_nh_ca_f_cmi = 0.0553;
  parameter Real init_nh_ca_f_cms = 0.02992;
  parameter Real init_nh_ca_f_cq = 0.3463;
  parameter Real init_nh_ca_f_csl = 4.84300E-05;

  Real nh_ca_f_tc = buffSteady(nh.ca.tc.k, nh.ca.tc.kb, ca_low) - init_nh_ca_f_tc;
  Real nh_ca_f_cmi = buffSteady(nh.ca.cm_cyto.k, nh.ca.cm_cyto.kb, ca_low) - init_nh_ca_f_cmi;
  Real nh_ca_f_cms = buffSteady(nh.ca.cm_sub.k, nh.ca.cm_sub.kb, ca_low) - init_nh_ca_f_cms;
  Real nh_ca_f_cq = buffSteady(nh.ca.cq.k, nh.ca.cq.kb, ca_high) - init_nh_ca_f_cq;
  Real nh_ca_f_csl = buffSteady(nh.ca.cm_sl.k, nh.ca.cm_sl.kb, ca_low) - init_nh_ca_f_csl;
  BuffSteady2 nh_tm(
    k = nh.ca.tmc.k,
    kb = nh.ca.tmc.kb,
    k2 = nh.ca.tmm.k,
    kb2 = nh.ca.tmm.kb,
    c2 = nh.ca.mg.c_const,
    c = ca_low
  );
  Real nh_ca_f_tmc = nh_tm.f - init_nh_ca_f_tmc;
  Real nh_ca_f_tmm = nh_tm.f2 - init_nh_ca_f_tmm;

  parameter Real steady_nh_ca_f_tc = buffSteady(nh.ca.tc.k, nh.ca.tc.kb, init_nh_ca_cyto);
  parameter Real steady_nh_ca_f_cmi = buffSteady(nh.ca.cm_cyto.k, nh.ca.cm_cyto.kb, init_nh_ca_cyto);
  parameter Real steady_nh_ca_f_cms = buffSteady(nh.ca.cm_sub.k, nh.ca.cm_sub.kb, init_nh_ca_sub);
  parameter Real steady_nh_ca_f_cq = buffSteady(nh.ca.cq.k, nh.ca.cq.kb, init_nh_ca_jsr);
  parameter Real steady_nh_ca_f_csl = buffSteady(nh.ca.cm_sl.k, nh.ca.cm_sl.kb, init_nh_ca_sub);
  parameter Real steady_nh_ca_f_tmc = buffSteady2(nh.ca.tmc.k, nh.ca.tmc.kb, init_nh_ca_cyto, nh.ca.tmm.k, nh.ca.tmm.kb, nh.ca.mg.c_const);
  parameter Real steady_nh_ca_f_tmm = buffSteady2(nh.ca.tmm.k, nh.ca.tmm.kb, nh.ca.mg.c_const, nh.ca.tmc.k, nh.ca.tmc.kb, init_nh_ca_cyto);

  Boolean step_nh_ca_cyto = ca_low > init_nh_ca_cyto;
  Boolean step_nh_ca_sub = ca_low > init_nh_ca_sub;
  Boolean step_nh_ca_jsr = ca_high > init_nh_ca_jsr;
  Boolean step_nh_ca_nsr = ca_high > init_nh_ca_nsr;

equation
  (temp_f, temp_f2) = buffSteady2(an.ca.tmc.k, an.ca.tmc.kb, ca_low, an.ca.tmm.k, an.ca.tmm.kb, an.ca.mg.c_const);
  connect(an.p, vc_an.p);
  connect(an.n, vc_an.n);
  connect(n.p, vc_n.p);
  connect(n.n, vc_n.n);
  connect(nh.p, vc_nh.p);
  connect(nh.n, vc_nh.n);
  connect(sim_buff_ca_cyto.substance, sim_buff_tc.site);
  connect(sim_buff_ca_cyto.substance, sim_buff_tmc.site);
  connect(sim_buff_mg.substance, sim_buff_tmm.site);
  connect(sim_buff_tmc.f_out, sim_buff_tmm.f_other);
  connect(sim_buff_tmm.f_out, sim_buff_tmc.f_other);
  der(v) = 0.2;
  der(ca_low) = 1e-3;
  der(ca_high) = 1.5;
  // |(an|n|nh)\.(na|cal|to|kr|hcn|st)\.(act|inact).*
annotation(
  experiment(StartTime = 0, StopTime = 5, Tolerance = 1e-6, Interval = 0.01),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="(an|n|nh|step)_.*")
);
end SteadyStates;

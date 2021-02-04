within InaMo.Examples.ComponentTests;
model SteadyStates "calculates steady states at different voltages"
  // used to determine whether starting values in C++/CellML correlate to steady states
  // Results can be found in notes/InadaCompareEquationsAndParameters.ods
  // (blue text = steady state, red text = not steady state)
  extends Modelica.Icons.Example;
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
  VoltageClamp vc_an(v_stim = init_an_v) "voltage clamp attached to AN cell";
  VoltageClamp vc_n(v_stim = init_n_v) "voltage clamp attached to N cell";
  VoltageClamp vc_nh(v_stim = init_nh_v) "voltage clamp attached to NH cell";
  // NOTE currently the initial values are not forwarded to the cell models
  // should we do that or is it unnecessary?
  ANCell an(
    l2.use_init=false,
    ca.cyto.c_start=init_an_ca_cyto,
    ca.sub.c_start=init_an_ca_sub,
    ca.jsr.c_start=init_an_ca_jsr,
    ca.nsr.c_start=init_an_ca_nsr,
    ca.cq.k = param_all_ca_cq_k,
    ca.tm.k_a = param_all_ca_tmc_k
  ) "AN cell";
  NCell n(
    l2.use_init=false,
    ca.cyto.c_start=init_n_ca_cyto,
    ca.sub.c_start=init_n_ca_sub,
    ca.jsr.c_start=init_n_ca_jsr,
    ca.nsr.c_start=init_n_ca_nsr,
    ca.cq.k = param_all_ca_cq_k,
    ca.tm.k_a = param_all_ca_tmc_k
  ) "N cell";
  NHCell nh(
    l2.use_init=false,
    ca.cyto.c_start=init_nh_ca_cyto,
    ca.sub.c_start=init_nh_ca_sub,
    ca.jsr.c_start=init_nh_ca_jsr,
    ca.nsr.c_start=init_nh_ca_nsr,
    ca.cq.k = param_all_ca_cq_k,
    ca.tm.k_a = param_all_ca_tmc_k
  ) "NH cell";
  SI.Voltage v(start=-0.1, fixed=true) "input voltage for calculation of steady states (not used for cell models, which are held at constant voltage)";
  SI.Concentration ca_low(start=0, fixed=true) "low Ca2+ concentration (for [Ca2+]_sub and [Ca2+]_cyto)";
  SI.Concentration ca_high(start=0, fixed=true) "high Ca2+ concentration (for [Ca2+]_jsr and [Ca2+]_nsr)";

  parameter SI.Voltage init_an_v = -0.070030 "initial voltage for AN cell";
  parameter SI.Voltage init_n_v = -6.213E-02 "initial voltage for N cell";
  parameter SI.Voltage init_nh_v = -6.86300E-02 "initial voltage for NH cell";

  // some relevant parameters differ between model versions
  parameter Real param_all_ca_cq_k = 534 "value for parameter ca.cq.k in all cell types";
  parameter Real param_all_ca_tmc_k = 227700 "value for parameter ca.tm.k_a in all cell types";

  Boolean step_an_v = v > init_an_v "step from false to true indicates time stamp where v = init_an_v is achieved";
  Boolean step_n_v = v > init_n_v "step from false to true indicates time stamp where v = init_n_v is achieved";
  Boolean step_nh_v = v > init_nh_v "step from false to true indicates time stamp where v = init_nh_v is achieved";

  ////// Tests for buffSteady and BuffSteady2 //////

  ConstantConcentration sim_buff_ca_cyto(c_const=init_an_ca_cyto) "Ca2+ concentration in cytosol used to test buffSteady and BuffSteady2";
  Buffer sim_buff_tc(n_tot=an.ca.tc.n_tot, f_start=init_an_ca_f_tc, k=an.ca.tc.k, kb=an.ca.tc.kb) "copy of an.ca.tc used to test buffSteady function";
  ConstantConcentration sim_buff_mg(c_const=an.ca.mg.c_const) "Mg2+ concentration in cytosol used to test BuffSteady2 model";
  Buffer2 sim_buff_tm(
    n_tot=an.ca.tm.n_tot, vol=an.ca.tm.vol,
    f_a_start=init_an_ca_f_tmc, k_a=an.ca.tm.k_a, kb_a=an.ca.tm.kb_a,
    f_b_start=init_an_ca_f_tmm, k_b=an.ca.tm.k_b, kb_b=an.ca.tm.kb_b
  ) "copy of an.ca.tm used to test BuffSteady2";

  BuffSteady2 sim_buff_tm_steady(
    k = sim_buff_tm.k_a,
    kb = sim_buff_tm.kb_a,
    k2 = sim_buff_tm.k_b,
    kb2 = sim_buff_tm.kb_b,
    c2 = sim_buff_mg.c_const,
    c = sim_buff_ca_cyto.c_const
  ) "calculates steady state for sim_buff_tm";

  Real sim_buff_f_tc = buffSteady(an.ca.tc.k, an.ca.tc.kb, init_an_ca_cyto) - sim_buff_tc.f
    "difference between calculated steady state of sim_buff_tc and actual value (should decline if implementation is correct)";
  Real sim_buff_f_tmc = sim_buff_tm_steady.f - sim_buff_tm.occupied_a.amount / sim_buff_tm.n_tot
    "difference between calculated steady state of sim_buff_tm.occupied_a and actual value (should decline if implementation is correct)";
  Real sim_buff_f_tmm = sim_buff_tm_steady.f2 - sim_buff_tm.occupied_b.amount / sim_buff_tm.n_tot
    "difference between calculated steady state of sim_buff_tm.occupied_b and actual value (should decline if implementation is correct)";

  ///////// AN cell //////////////

  parameter Real init_an_na_act = 0.01227 "initial value of an.na.act.f";
  parameter Real init_an_na_inact_fast = 0.717 "initial value of an.na.inact_fast.f";
  parameter Real init_an_na_inact_slow = 0.6162 "initial value of an.na.inact_slow.f";
  parameter Real init_an_cal_act = 4.07E-05 "initial value of an.cal.act.f";
  parameter Real init_an_cal_inact_fast = 0.9985 "initial value of an.cal.inact_fast.f";
  parameter Real init_an_cal_inact_slow = 0.9875 "initial value of an.cal.inact_slow.f";
  parameter Real init_an_to_act = 0.008857 "initial value of an.to.act.f";
  parameter Real init_an_to_inact_fast = 0.8734 "initial value of an.to.inact_fast.f";
  parameter Real init_an_to_inact_slow = 0.1503 "initial value of an.to.inact_slow.f";
  parameter Real init_an_kr_act_fast = 0.07107 "initial value of an.kr.act_fast.f";
  parameter Real init_an_kr_act_slow = 0.0484 "initial value of an.kr.act_slow.f";
  parameter Real init_an_kr_inact = 0.9866 "initial value of an.kr.inact.f";

  Real an_na_act = an.na.act.falpha(v) / (an.na.act.falpha(v) + an.na.act.fbeta(v)) - init_an_na_act "difference between initial value and calculated steady state at current input voltage for an.na.act";
  Real an_na_inact_fast = an.na.inact_fast.fsteady(v) - init_an_na_inact_fast "difference between initial value and calculated steady state at current input voltage for an.na.inact_fast";
  Real an_na_inact_slow = an.na.inact_slow.fsteady(v) - init_an_na_inact_slow "difference between initial value and calculated steady state at current input voltage for an.na.inact_slow";
  Real an_cal_act = an.cal.act.fsteady(v) - init_an_cal_act "difference between initial value and calculated steady state at current input voltage for an.cal.act";
  Real an_cal_inact_fast = an.cal.inact_fast.fsteady(v) - init_an_cal_inact_fast "difference between initial value and calculated steady state at current input voltage for an.cal.inact_fast";
  Real an_cal_inact_slow = an.cal.inact_slow.fsteady(v) - init_an_cal_inact_slow "difference between initial value and calculated steady state at current input voltage for an.cal.inact_slow";
  Real an_to_act = an.to.act.fsteady(v) - init_an_to_act "difference between initial value and calculated steady state at current input voltage for an.to.act";
  Real an_to_inact_fast = an.to.inact_fast.fsteady(v) - init_an_to_inact_fast "difference between initial value and calculated steady state at current input voltage for an.to.inact_fast";
  Real an_to_inact_slow = an.to.inact_slow.fsteady(v) - init_an_to_inact_slow "difference between initial value and calculated steady state at current input voltage for an.to.inact_slow";
  Real an_kr_act_fast = an.kr.act_fast.fsteady(v) - init_an_kr_act_fast "difference between initial value and calculated steady state at current input voltage for an.kr.act_fast";
  Real an_kr_act_slow = an.kr.act_slow.fsteady(v) - init_an_kr_act_slow "difference between initial value and calculated steady state at current input voltage for an.kr.act_slow";
  Real an_kr_inact = an.kr.inact.fsteady(v) - init_an_kr_inact "difference between initial value and calculated steady state at current input voltage for an.kr.inact";

  parameter Real steady_an_na_act = an.na.act.falpha(init_an_v) / (an.na.act.falpha(init_an_v) + an.na.act.fbeta(init_an_v)) "calculated steady state at initial voltage for an.na.act";
  parameter Real steady_an_na_inact_fast = an.na.inact_fast.fsteady(init_an_v) "calculated steady state at initial voltage for an.na.inact_fast";
  parameter Real steady_an_na_inact_slow = an.na.inact_slow.fsteady(init_an_v) "calculated steady state at initial voltage for an.na.inact_slow";
  parameter Real steady_an_cal_act = an.cal.act.fsteady(init_an_v) "calculated steady state at initial voltage for an.cal.act";
  parameter Real steady_an_cal_inact_fast = an.cal.inact_fast.fsteady(init_an_v) "calculated steady state at initial voltage for an.cal.inact_fast";
  parameter Real steady_an_cal_inact_slow = an.cal.inact_slow.fsteady(init_an_v) "calculated steady state at initial voltage for an.cal.inact_slow";
  parameter Real steady_an_to_act = an.to.act.fsteady(init_an_v) "calculated steady state at initial voltage for an.to.act";
  parameter Real steady_an_to_inact_fast = an.to.inact_fast.fsteady(init_an_v) "calculated steady state at initial voltage for an.to.inact_fast";
  parameter Real steady_an_to_inact_slow = an.to.inact_slow.fsteady(init_an_v) "calculated steady state at initial voltage for an.to.inact_slow";
  parameter Real steady_an_kr_act_fast = an.kr.act_fast.fsteady(init_an_v) "calculated steady state at initial voltage for an.kr.act_fast";
  parameter Real steady_an_kr_act_slow = an.kr.act_slow.fsteady(init_an_v) "calculated steady state at initial voltage for an.kr.act_slow";
  parameter Real steady_an_kr_inact = an.kr.inact.fsteady(init_an_v) "calculated steady state at initial voltage for an.kr.inact";

  Real sim_an_na_act = an.na.act.falpha(vc_an.v) / (an.na.act.falpha(vc_an.v) + an.na.act.fbeta(vc_an.v)) - an.na.act.n "difference between steady state at clamp voltage and current value in cell model for an.na.act";
  Real sim_an_na_inact_fast = an.na.inact_fast.fsteady(vc_an.v) - an.na.inact_fast.n "difference between steady state at clamp voltage and current value in cell model for an.na.inact_fast";
  Real sim_an_na_inact_slow = an.na.inact_slow.fsteady(vc_an.v) - an.na.inact_slow.n "difference between steady state at clamp voltage and current value in cell model for an.na.inact_slow";
  Real sim_an_cal_act = an.cal.act.fsteady(vc_an.v) - an.cal.act.n "difference between steady state at clamp voltage and current value in cell model for an.cal.act";
  Real sim_an_cal_inact_fast = an.cal.inact_fast.fsteady(vc_an.v) - an.cal.inact_fast.n "difference between steady state at clamp voltage and current value in cell model for an.cal.inact_fast";
  Real sim_an_cal_inact_slow = an.cal.inact_slow.fsteady(vc_an.v) - an.cal.inact_slow.n "difference between steady state at clamp voltage and current value in cell model for an.cal.inact_slow";
  Real sim_an_to_act = an.to.act.fsteady(vc_an.v) - an.to.act.n "difference between steady state at clamp voltage and current value in cell model for an.to.act";
  Real sim_an_to_inact_fast = an.to.inact_fast.fsteady(vc_an.v) - an.to.inact_fast.n "difference between steady state at clamp voltage and current value in cell model for an.to.inact_fast";
  Real sim_an_to_inact_slow = an.to.inact_slow.fsteady(vc_an.v) - an.to.inact_slow.n "difference between steady state at clamp voltage and current value in cell model for an.to.inact_slow";
  Real sim_an_kr_act_fast = an.kr.act_fast.fsteady(vc_an.v) - an.kr.act_fast.n "difference between steady state at clamp voltage and current value in cell model for an.kr.act_fast";
  Real sim_an_kr_act_slow = an.kr.act_slow.fsteady(vc_an.v) - an.kr.act_slow.n "difference between steady state at clamp voltage and current value in cell model for an.kr.act_slow";
  Real sim_an_kr_inact = an.kr.inact.fsteady(vc_an.v) - an.kr.inact.n "difference between steady state at clamp voltage and current value in cell model for an.kr.inact";

  parameter SI.Concentration init_an_ca_cyto = 1.2060E-04 "initial value of an.ca.cyto.con";
  parameter SI.Concentration init_an_ca_sub = 6.3970E-05 "initial value of an.ca.sub.con";
  parameter SI.Concentration init_an_ca_jsr = 0.4273 "initial value of an.ca.jsr.con";
  parameter SI.Concentration init_an_ca_nsr = 1.068 "initial value of an.ca.nsr.con";
  parameter Real init_an_ca_f_tc = 0.02359 "initial value of an.ca.tc.f";
  parameter Real init_an_ca_f_cmi = 0.04845 "initial value of an.ca.cm_cyto.f";
  parameter Real init_an_ca_f_cms = 0.02626 "initial value of an.ca.cm_sub.f";
  parameter Real init_an_ca_f_cq = 0.3379 "initial value of an.ca.cq.f";
  parameter Real init_an_ca_f_csl = 3.936E-05 "initial value of an.ca.cm_sl.f";
  parameter Real init_an_ca_f_tmc = 0.3667 "initial value of an.ca.tmc.f";
  parameter Real init_an_ca_f_tmm = 0.5594 "initial value of an.ca.tmm.f";

  Real an_ca_f_tc = buffSteady(an.ca.tc.k, an.ca.tc.kb, ca_low) - init_an_ca_f_tc "difference between calculated steady state at a concentration of ca_low and initial value of an.ca.tc.f";
  Real an_ca_f_cmi = buffSteady(an.ca.cm_cyto.k, an.ca.cm_cyto.kb, ca_low) - init_an_ca_f_cmi "difference between calculated steady state at a concentration of ca_low and initial value of an.ca.cm_cyto.f";
  Real an_ca_f_cms = buffSteady(an.ca.cm_sub.k, an.ca.cm_sub.kb, ca_low) - init_an_ca_f_cms "difference between calculated steady state at a concentration of ca_low and initial value of an.ca.cm_sub.f";
  Real an_ca_f_cq = buffSteady(an.ca.cq.k, an.ca.cq.kb, ca_high) - init_an_ca_f_cq "difference between calculated steady state at a concentration of ca_high and initial value of an.ca.cq.f";
  Real an_ca_f_csl = buffSteady(an.ca.cm_sl.k, an.ca.cm_sl.kb, ca_low) - init_an_ca_f_csl "difference between calculated steady state at a concentration of ca_low and initial value of an.ca.cm_sl.f";
  BuffSteady2 an_tm(
    k = an.ca.tm.k_a,
    kb = an.ca.tm.kb_a,
    k2 = an.ca.tm.k_b,
    kb2 = an.ca.tm.kb_b,
    c2 = an.ca.mg.c_const,
    c = ca_low
  ) "helper model to calculate steady states for an.ca.tmm and an.ca.tmc";
  Real temp_f "steady state of an.ca.tmc.f calculated with buffSteady2";
  Real temp_f2 "steady state of an.ca.tmm.f calculated with buffSteady2";
  Real an_ca_f_tmc = an_tm.f - init_an_ca_f_tmc "difference between calculated steady state at a concentration of ca_low and initial value of an.ca.tmc.f";
  Real an_ca_f_tmm = an_tm.f2 - init_an_ca_f_tmm "difference between calculated steady state at a concentration of ca_low and initial value of an.ca.tmm.f";
  Real an_ca_f_tmc2 = temp_f - init_an_ca_f_tmc "same as an_ca_f_tmc but using bufferSteady2 function instead of BufferSteady2 model";
  Real an_ca_f_tmm2 = temp_f2 - init_an_ca_f_tmm "same as an_ca_f_tmm but using bufferSteady2 function instead of BufferSteady2 model";

  parameter Real steady_an_ca_f_tc = buffSteady(an.ca.tc.k, an.ca.tc.kb, init_an_ca_cyto) "calculated steady state at initial Ca2+ concentrations for an.ca.tc.f";
  parameter Real steady_an_ca_f_cmi = buffSteady(an.ca.cm_cyto.k, an.ca.cm_cyto.kb, init_an_ca_cyto) "calculated steady state at initial Ca2+ concentrations for an.ca.cm_cyto.f";
  parameter Real steady_an_ca_f_cms = buffSteady(an.ca.cm_sub.k, an.ca.cm_sub.kb, init_an_ca_sub) "calculated steady state at initial Ca2+ concentrations for an.ca.cm_sub.f";
  parameter Real steady_an_ca_f_cq = buffSteady(an.ca.cq.k, an.ca.cq.kb, init_an_ca_jsr) "calculated steady state at initial Ca2+ concentrations for an.ca.cq.f";
  parameter Real steady_an_ca_f_csl = buffSteady(an.ca.cm_sl.k, an.ca.cm_sl.kb, init_an_ca_sub) "calculated steady state at initial Ca2+ concentrations for an.ca.cm_sl.f";
  // NOTE: each expression uses only first return value
  parameter Real steady_an_ca_f_tmc = buffSteady2(an.ca.tm.k_a, an.ca.tm.kb_a, init_an_ca_cyto, an.ca.tm.k_b, an.ca.tm.kb_b, an.ca.mg.c_const) "calculated steady state at initial Ca2+ concentrations for an.ca.tmc.f";
  parameter Real steady_an_ca_f_tmm = buffSteady2(an.ca.tm.k_b, an.ca.tm.kb_b, an.ca.mg.c_const, an.ca.tm.k_a, an.ca.tm.kb_a, init_an_ca_cyto) "calculated steady state at initial Ca2+ concentrations for an.ca.tmm.f";

  Boolean step_an_ca_cyto = ca_low > init_an_ca_cyto "step from false to true indicates time stamp where ca_low = init_an_ca_cyto is achieved";
  Boolean step_an_ca_sub = ca_low > init_an_ca_sub "step from false to true indicates time stamp where ca_low = init_an_ca_sub is achieved";
  Boolean step_an_ca_jsr = ca_high > init_an_ca_jsr "step from false to true indicates time stamp where ca_high = init_an_ca_jsr is achieved";
  Boolean step_an_ca_nsr = ca_high > init_an_ca_nsr "step from false to true indicates time stamp where ca_high = init_an_ca_nsr is achieved";

  ///////// N cell //////////////
  parameter Real init_n_cal_act = 1.533E-04 "initial value of n.cal.act";
  parameter Real init_n_cal_inact_fast = 0.6861 "initial value of n.cal.inact_fast";
  parameter Real init_n_cal_inact_slow = 0.4441 "initial value of n.cal.inact_slow";
  parameter Real init_n_kr_act_fast = 0.6067 "initial value of n.kr.act_fast";
  parameter Real init_n_kr_act_slow = 0.1287 "initial value of n.kr_act_slow";
  parameter Real init_n_kr_inact = 0.9775 "initial value of n.kr_inact";
  parameter Real init_n_f_act = 0.03825 "initial value of n.f.act";
  parameter Real init_n_st_act = 0.1933 "initial value of n.st.act";
  parameter Real init_n_st_inact = 0.4886 "initial value of n.st.inact";

  Real n_cal_act = an.cal.act.fsteady(v) - init_n_cal_act "difference between initial value and calculated steady state at current input voltage for n.cal.act";
  Real n_cal_inact_fast = an.cal.inact_fast.fsteady(v) - init_n_cal_inact_fast "difference between initial value and calculated steady state at current input voltage for n.cal.inact_fast";
  Real n_cal_inact_slow = an.cal.inact_slow.fsteady(v) - init_n_cal_inact_slow "difference between initial value and calculated steady state at current input voltage for n.cal.inact_slow";
  Real n_kr_act_fast = n.kr.act_fast.fsteady(v) - init_n_kr_act_fast "difference between initial value and calculated steady state at current input voltage for n.kr.act_fast";
  Real n_kr_act_slow = n.kr.act_slow.fsteady(v) - init_n_kr_act_slow "difference between initial value and calculated steady state at current input voltage for n.kr_act_slow";
  Real n_kr_inact = n.kr.inact.fsteady(v) - init_n_kr_inact "difference between initial value and calculated steady state at current input voltage for n.kr_inact";
  Real n_f_act = n.hcn.act.fsteady(v) - init_n_f_act "difference between initial value and calculated steady state at current input voltage for n.f.act";
  Real n_st_act = n.st.act.fsteady(v) - init_n_st_act "difference between initial value and calculated steady state at current input voltage for n.st.act";
  Real n_st_inact = n.st.inact.falpha(v) / (n.st.inact.falpha(v) + n.st.inact.fbeta(v)) - init_n_st_inact "difference between initial value and calculated steady state at current input voltage for n.st.inact";

  Real steady_n_cal_act = an.cal.act.fsteady(init_n_v) "calculated steady state at initial voltage for n.cal.act";
  Real steady_n_cal_inact_fast = an.cal.inact_fast.fsteady(init_n_v) "calculated steady state at initial voltage for n.cal.inact_fast";
  Real steady_n_cal_inact_slow = an.cal.inact_slow.fsteady(init_n_v) "calculated steady state at initial voltage for n.cal.inact_slow";
  Real steady_n_kr_act_fast = n.kr.act_fast.fsteady(init_n_v) "calculated steady state at initial voltage for n.kr.act_fast";
  Real steady_n_kr_act_slow = n.kr.act_slow.fsteady(init_n_v) "calculated steady state at initial voltage for n.kr_act_slow";
  Real steady_n_kr_inact = n.kr.inact.fsteady(init_n_v) "calculated steady state at initial voltage for n.kr_inact";
  Real steady_n_f_act = n.hcn.act.fsteady(init_n_v) "calculated steady state at initial voltage for n.f.act";
  Real steady_n_st_act = n.st.act.fsteady(init_n_v) "calculated steady state at initial voltage for n.st.act";
  Real steady_n_st_inact = n.st.inact.falpha(init_n_v) / (n.st.inact.falpha(init_n_v) + n.st.inact.fbeta(init_n_v)) "calculated steady state at initial voltage for n.st.inact";

  Real sim_n_cal_act = an.cal.act.fsteady(vc_n.v) - n.cal.act.n "difference between steady state at clamp voltage and current value in cell model for n.cal.act";
  Real sim_n_cal_inact_fast = an.cal.inact_fast.fsteady(vc_n.v) - n.cal.inact_fast.n "difference between steady state at clamp voltage and current value in cell model for n.cal.inact_fast";
  Real sim_n_cal_inact_slow = an.cal.inact_slow.fsteady(vc_n.v) - n.cal.inact_slow.n "difference between steady state at clamp voltage and current value in cell model for n.cal.inact_slow";
  Real sim_n_kr_act_fast = n.kr.act_fast.fsteady(vc_n.v) - n.kr.act_fast.n "difference between steady state at clamp voltage and current value in cell model for n.kr.act_fast";
  Real sim_n_kr_act_slow = n.kr.act_slow.fsteady(vc_n.v) - n.kr.act_slow.n "difference between steady state at clamp voltage and current value in cell model for n.kr_act_slow";
  Real sim_n_kr_inact = n.kr.inact.fsteady(vc_n.v) - n.kr.inact.n "difference between steady state at clamp voltage and current value in cell model for n.kr_inact";
  Real sim_n_f_act = n.hcn.act.fsteady(vc_n.v) - n.hcn.act.n "difference between steady state at clamp voltage and current value in cell model for n.f.act";
  Real sim_n_st_act = n.st.act.fsteady(vc_n.v) - n.st.act.n "difference between steady state at clamp voltage and current value in cell model for n.st.act";
  Real sim_n_st_inact = n.st.inact.falpha(vc_n.v) / (n.st.inact.falpha(vc_n.v) + n.st.inact.fbeta(vc_n.v)) - n.st.inact.n "difference between steady state at clamp voltage and current value in cell model for n.st.inact";

  parameter SI.Concentration init_n_ca_cyto = 3.623E-04 "initial value of n.ca.cyto.con";
  parameter SI.Concentration init_n_ca_sub = 2.294E-04 "initial value of n.ca.sub.con";
  parameter SI.Concentration init_n_ca_jsr = 0.08227 "initial value of n.ca.jsr.con";
  parameter SI.Concentration init_n_ca_nsr = 1.146 "initial value of n.ca.nsr.con";

  parameter Real init_n_ca_f_tc = 0.6838 "initial value of n.ca.tc.f";
  parameter Real init_n_ca_f_tmc = 0.6192 "initial value of n.ca.cm_cyto.f";
  parameter Real init_n_ca_f_tmm = 0.3363 "initial value of n.ca.cm_sub.f";
  parameter Real init_n_ca_f_cmi = 0.1336 "initial value of n.ca.cq.f";
  parameter Real init_n_ca_f_cms = 0.08894 "initial value of n.ca.cm_sl.f";
  parameter Real init_n_ca_f_cq = 0.08736 "initial value of n.ca.tmc.f";
  parameter Real init_n_ca_f_csl = 4.7640E-05 "initial value of n.ca.tmm.f";

  Real n_ca_f_tc = buffSteady(n.ca.tc.k, n.ca.tc.kb, ca_low) - init_n_ca_f_tc "difference between calculated steady state at a concentration of ca_low and initial value of n.ca.tc.f";
  Real n_ca_f_cmi = buffSteady(n.ca.cm_cyto.k, n.ca.cm_cyto.kb, ca_low) - init_n_ca_f_cmi "difference between calculated steady state at a concentration of ca_low and initial value of n.ca.cm_cyto.f";
  Real n_ca_f_cms = buffSteady(n.ca.cm_sub.k, n.ca.cm_sub.kb, ca_low) - init_n_ca_f_cms "difference between calculated steady state at a concentration of ca_low and initial value of n.ca.cm_sub.f";
  Real n_ca_f_cq = buffSteady(n.ca.cq.k, n.ca.cq.kb, ca_high) - init_n_ca_f_cq "difference between calculated steady state at a concentration of ca_high and initial value of n.ca.cq.f";
  Real n_ca_f_csl = buffSteady(n.ca.cm_sl.k, n.ca.cm_sl.kb, ca_low) - init_n_ca_f_csl "difference between calculated steady state at a concentration of ca_low and initial value of n.ca.cm_sl.f";
  BuffSteady2 n_tm(
    k = n.ca.tm.k_a,
    kb = n.ca.tm.kb_a,
    k2 = n.ca.tm.k_b,
    kb2 = n.ca.tm.kb_b,
    c2 = n.ca.mg.c_const,
    c = ca_low
  ) "helper model to calculate steady states for n.ca.tmm and n.ca.tmc";
  Real n_ca_f_tmc = n_tm.f - init_n_ca_f_tmc "difference between calculated steady state at a concentration of ca_low and initial value of n.ca.tmc.f";
  Real n_ca_f_tmm = n_tm.f2 - init_n_ca_f_tmm "difference between calculated steady state at a concentration of ca_low and initial value of n.ca.tmm.f";

  parameter Real steady_n_ca_f_tc = buffSteady(n.ca.tc.k, n.ca.tc.kb, init_n_ca_cyto) "calculated steady state at initial Ca2+ concentrations for n.ca.tc.f";
  parameter Real steady_n_ca_f_cmi = buffSteady(n.ca.cm_cyto.k, n.ca.cm_cyto.kb, init_n_ca_cyto) "calculated steady state at initial Ca2+ concentrations for n.ca.cm_cyto.f";
  parameter Real steady_n_ca_f_cms = buffSteady(n.ca.cm_sub.k, n.ca.cm_sub.kb, init_n_ca_sub) "calculated steady state at initial Ca2+ concentrations for n.ca.cm_sub.f";
  parameter Real steady_n_ca_f_cq = buffSteady(n.ca.cq.k, n.ca.cq.kb, init_n_ca_jsr) "calculated steady state at initial Ca2+ concentrations for n.ca.cq.f";
  parameter Real steady_n_ca_f_csl = buffSteady(n.ca.cm_sl.k, n.ca.cm_sl.kb, init_n_ca_sub) "calculated steady state at initial Ca2+ concentrations for n.ca.cm_sl.f";
  parameter Real steady_n_ca_f_tmc = buffSteady2(n.ca.tm.k_a, n.ca.tm.kb_a, init_n_ca_cyto, n.ca.tm.k_b, n.ca.tm.kb_b, n.ca.mg.c_const) "calculated steady state at initial Ca2+ concentrations for n.ca.tmc.f";
  parameter Real steady_n_ca_f_tmm = buffSteady2(n.ca.tm.k_b, n.ca.tm.kb_b, n.ca.mg.c_const, n.ca.tm.k_a, n.ca.tm.kb_a, init_n_ca_cyto) "calculated steady state at initial Ca2+ concentrations for n.ca.tmm.f";

  Boolean step_n_ca_cyto = ca_low > init_n_ca_cyto "step from false to true indicates time stamp where ca_low = init_n_ca_cyto is achieved";
  Boolean step_n_ca_sub = ca_low > init_n_ca_sub "step from false to true indicates time stamp where ca_low = init_n_ca_sub is achieved";
  Boolean step_n_ca_jsr = ca_high > init_n_ca_jsr "step from false to true indicates time stamp where ca_high = init_n_ca_jsr is achieved";
  Boolean step_n_ca_nsr = ca_high > init_n_ca_nsr "step from false to true indicates time stamp where ca_high = init_n_ca_nsr is achieved";

  ///////// NH cell //////////////

  parameter Real init_nh_na_act = 0.01529 "initial value of nh.na.act.f";
  parameter Real init_nh_na_inact_fast = 0.6438 "initial value of nh.na.inact_fast.f";
  parameter Real init_nh_na_inact_slow = 0.5552 "initial value of nh.na.inact_slow.f";
  parameter Real init_nh_cal_act = 5.0250E-05 "initial value of nh.cal.act.f";
  parameter Real init_nh_cal_inact_fast = 0.9981 "initial value of nh.cal.inact_fast.f";
  parameter Real init_nh_cal_inact_slow = 0.9831 "initial value of nh.cal.inact_slow.f";
  parameter Real init_nh_to_act = 9.581E-03 "initial value of nh.to.act.f";
  parameter Real init_nh_to_inact_fast = 0.864 "initial value of nh.to.inact_fast.f";
  parameter Real init_nh_to_inact_slow = 0.1297 "initial value of nh.to.inact_slow.f";
  parameter Real init_nh_kr_act_fast = 0.09949 "initial value of nh.kr.act_fast.f";
  parameter Real init_nh_kr_act_slow = 0.07024 "initial value of nh.kr.act_slow.f";
  parameter Real init_nh_kr_inact = 0.9853 "initial value of nh.kr.inact.f";

  Real nh_na_act = nh.na.act.falpha(v) / (nh.na.act.falpha(v) + nh.na.act.fbeta(v)) - init_nh_na_act "difference between initial value and calculated steady state at current input voltage for nh.na.act";
  Real nh_na_inact_fast = nh.na.inact_fast.fsteady(v) - init_nh_na_inact_fast "difference between initial value and calculated steady state at current input voltage for nh.na.inact_fast";
  Real nh_na_inact_slow = nh.na.inact_slow.fsteady(v) - init_nh_na_inact_slow "difference between initial value and calculated steady state at current input voltage for nh.na.inact_slow";
  Real nh_cal_act = nh.cal.act.fsteady(v) - init_nh_cal_act "difference between initial value and calculated steady state at current input voltage for nh.cal.act";
  Real nh_cal_inact_fast = nh.cal.inact_fast.fsteady(v) - init_nh_cal_inact_fast "difference between initial value and calculated steady state at current input voltage for nh.cal.inact_fast";
  Real nh_cal_inact_slow = nh.cal.inact_slow.fsteady(v) - init_nh_cal_inact_slow "difference between initial value and calculated steady state at current input voltage for nh.cal.inact_slow";
  Real nh_to_act = nh.to.act.fsteady(v) - init_nh_to_act "difference between initial value and calculated steady state at current input voltage for nh.to.act";
  Real nh_to_inact_fast = nh.to.inact_fast.fsteady(v) - init_nh_to_inact_fast "difference between initial value and calculated steady state at current input voltage for nh.to.inact_fast";
  Real nh_to_inact_slow = nh.to.inact_slow.fsteady(v) - init_nh_to_inact_slow "difference between initial value and calculated steady state at current input voltage for nh.to.inact_slow";
  Real nh_kr_act_fast = nh.kr.act_fast.fsteady(v) - init_nh_kr_act_fast "difference between initial value and calculated steady state at current input voltage for nh.kr.act_fast";
  Real nh_kr_act_slow = nh.kr.act_slow.fsteady(v) - init_nh_kr_act_slow "difference between initial value and calculated steady state at current input voltage for nh.kr.act_slow";
  Real nh_kr_inact = nh.kr.inact.fsteady(v) - init_nh_kr_inact "difference between initial value and calculated steady state at current input voltage for nh.kr.inact";

  parameter Real steady_nh_na_act = nh.na.act.falpha(init_nh_v) / (nh.na.act.falpha(init_nh_v) + nh.na.act.fbeta(init_nh_v)) "calculated steady state at initial voltage for nh.na.act";
  parameter Real steady_nh_na_inact_fast = nh.na.inact_fast.fsteady(init_nh_v) "calculated steady state at initial voltage for nh.na.inact_fast";
  parameter Real steady_nh_na_inact_slow = nh.na.inact_slow.fsteady(init_nh_v) "calculated steady state at initial voltage for nh.na.inact_slow";
  parameter Real steady_nh_cal_act = nh.cal.act.fsteady(init_nh_v) "calculated steady state at initial voltage for nh.cal.act";
  parameter Real steady_nh_cal_inact_fast = nh.cal.inact_fast.fsteady(init_nh_v) "calculated steady state at initial voltage for nh.cal.inact_fast";
  parameter Real steady_nh_cal_inact_slow = nh.cal.inact_slow.fsteady(init_nh_v) "calculated steady state at initial voltage for nh.cal.inact_slow";
  parameter Real steady_nh_to_act = nh.to.act.fsteady(init_nh_v) "calculated steady state at initial voltage for nh.to.act";
  parameter Real steady_nh_to_inact_fast = nh.to.inact_fast.fsteady(init_nh_v) "calculated steady state at initial voltage for nh.to.inact_fast";
  parameter Real steady_nh_to_inact_slow = nh.to.inact_slow.fsteady(init_nh_v) "calculated steady state at initial voltage for nh.to.inact_slow";
  parameter Real steady_nh_kr_act_fast = nh.kr.act_fast.fsteady(init_nh_v) "calculated steady state at initial voltage for nh.kr.act_fast";
  parameter Real steady_nh_kr_act_slow = nh.kr.act_slow.fsteady(init_nh_v) "calculated steady state at initial voltage for nh.kr.act_slow";
  parameter Real steady_nh_kr_inact = nh.kr.inact.fsteady(init_nh_v) "calculated steady state at initial voltage for nh.kr.inact";

  Real sim_nh_na_act = nh.na.act.falpha(vc_nh.v) / (nh.na.act.falpha(vc_nh.v) + nh.na.act.fbeta(vc_nh.v)) - nh.na.act.n "difference between steady state at clamp voltage and current value in cell model for nh.na.act";
  Real sim_nh_na_inact_fast = nh.na.inact_fast.fsteady(vc_nh.v) - nh.na.inact_fast.n "difference between steady state at clamp voltage and current value in cell model for nh.na.inact_fast";
  Real sim_nh_na_inact_slow = nh.na.inact_slow.fsteady(vc_nh.v) - nh.na.inact_slow.n "difference between steady state at clamp voltage and current value in cell model for nh.na.inact_slow";
  Real sim_nh_cal_act = nh.cal.act.fsteady(vc_nh.v) - nh.cal.act.n "difference between steady state at clamp voltage and current value in cell model for nh.cal.act";
  Real sim_nh_cal_inact_fast = nh.cal.inact_fast.fsteady(vc_nh.v) - nh.cal.inact_fast.n "difference between steady state at clamp voltage and current value in cell model for nh.cal.inact_fast";
  Real sim_nh_cal_inact_slow = nh.cal.inact_slow.fsteady(vc_nh.v) - nh.cal.inact_slow.n "difference between steady state at clamp voltage and current value in cell model for nh.cal.inact_slow";
  Real sim_nh_to_act = nh.to.act.fsteady(vc_nh.v) - nh.to.act.n "difference between steady state at clamp voltage and current value in cell model for nh.to.act";
  Real sim_nh_to_inact_fast = nh.to.inact_fast.fsteady(vc_nh.v) - nh.to.inact_fast.n "difference between steady state at clamp voltage and current value in cell model for nh.to.inact_fast";
  Real sim_nh_to_inact_slow = nh.to.inact_slow.fsteady(vc_nh.v) - nh.to.inact_slow.n "difference between steady state at clamp voltage and current value in cell model for nh.to.inact_slow";
  Real sim_nh_kr_act_fast = nh.kr.act_fast.fsteady(vc_nh.v) - nh.kr.act_fast.n "difference between steady state at clamp voltage and current value in cell model for nh.kr.act_fast";
  Real sim_nh_kr_act_slow = nh.kr.act_slow.fsteady(vc_nh.v) - nh.kr.act_slow.n "difference between steady state at clamp voltage and current value in cell model for nh.kr.act_slow";
  Real sim_nh_kr_inact = nh.kr.inact.fsteady(vc_nh.v) - nh.kr.inact.n "difference between steady state at clamp voltage and current value in cell model for nh.kr.inact";

  parameter SI.Concentration init_nh_ca_cyto = 1.38600E-04 "initial value of nh.ca.cyto.con";
  parameter SI.Concentration init_nh_ca_sub = 7.31400E-05 "initial value of nh.ca.sub.con";
  parameter SI.Concentration init_nh_ca_jsr = 0.4438 "initial value of nh.ca.jsr.con";
  parameter SI.Concentration init_nh_ca_nsr = 1.187 "initial value of nh.ca.nsr.con";
  parameter Real init_nh_ca_f_tc = 0.02703 "initial value of nh.ca.tc.f";
  parameter Real init_nh_ca_f_tmc = 0.402 "initial value of nh.ca.cm_cyto.f";
  parameter Real init_nh_ca_f_tmm = 0.5282 "initial value of nh.ca.cm_sub.f";
  parameter Real init_nh_ca_f_cmi = 0.0553 "initial value of nh.ca.cq.f";
  parameter Real init_nh_ca_f_cms = 0.02992 "initial value of nh.ca.cm_sl.f";
  parameter Real init_nh_ca_f_cq = 0.3463 "initial value of nh.ca.tmc.f";
  parameter Real init_nh_ca_f_csl = 4.84300E-05 "initial value of nh.ca.tmm.f";

  Real nh_ca_f_tc = buffSteady(nh.ca.tc.k, nh.ca.tc.kb, ca_low) - init_nh_ca_f_tc "difference between calculated steady state at a concentration of ca_low and initial value of nh.ca.tc.f";
  Real nh_ca_f_cmi = buffSteady(nh.ca.cm_cyto.k, nh.ca.cm_cyto.kb, ca_low) - init_nh_ca_f_cmi "difference between calculated steady state at a concentration of ca_low and initial value of nh.ca.cm_cyto.f";
  Real nh_ca_f_cms = buffSteady(nh.ca.cm_sub.k, nh.ca.cm_sub.kb, ca_low) - init_nh_ca_f_cms "difference between calculated steady state at a concentration of ca_low and initial value of nh.ca.cm_sub.f";
  Real nh_ca_f_cq = buffSteady(nh.ca.cq.k, nh.ca.cq.kb, ca_high) - init_nh_ca_f_cq "difference between calculated steady state at a concentration of ca_high and initial value of nh.ca.cq.f";
  Real nh_ca_f_csl = buffSteady(nh.ca.cm_sl.k, nh.ca.cm_sl.kb, ca_low) - init_nh_ca_f_csl "difference between calculated steady state at a concentration of ca_low and initial value of nh.ca.cm_sl.f";
  BuffSteady2 nh_tm(
    k = nh.ca.tm.k_a,
    kb = nh.ca.tm.kb_a,
    k2 = nh.ca.tm.k_b,
    kb2 = nh.ca.tm.kb_b,
    c2 = nh.ca.mg.c_const,
    c = ca_low
  ) "helper model to calculate steady states for nh.ca.tmm and nh.ca.tmc";
  Real nh_ca_f_tmc = nh_tm.f - init_nh_ca_f_tmc "difference between calculated steady state at a concentration of ca_low and initial value of nh.ca.tmc.f";
  Real nh_ca_f_tmm = nh_tm.f2 - init_nh_ca_f_tmm "difference between calculated steady state at a concentration of ca_low and initial value of nh.ca.tmm.f";

  parameter Real steady_nh_ca_f_tc = buffSteady(nh.ca.tc.k, nh.ca.tc.kb, init_nh_ca_cyto) "calculated steady state at initial Ca2+ concentrations for nh.ca.tc.f";
  parameter Real steady_nh_ca_f_cmi = buffSteady(nh.ca.cm_cyto.k, nh.ca.cm_cyto.kb, init_nh_ca_cyto) "calculated steady state at initial Ca2+ concentrations for nh.ca.cm_cyto.f";
  parameter Real steady_nh_ca_f_cms = buffSteady(nh.ca.cm_sub.k, nh.ca.cm_sub.kb, init_nh_ca_sub) "calculated steady state at initial Ca2+ concentrations for nh.ca.cm_sub.f";
  parameter Real steady_nh_ca_f_cq = buffSteady(nh.ca.cq.k, nh.ca.cq.kb, init_nh_ca_jsr) "calculated steady state at initial Ca2+ concentrations for nh.ca.cq.f";
  parameter Real steady_nh_ca_f_csl = buffSteady(nh.ca.cm_sl.k, nh.ca.cm_sl.kb, init_nh_ca_sub) "calculated steady state at initial Ca2+ concentrations for nh.ca.cm_sl.f";
  parameter Real steady_nh_ca_f_tmc = buffSteady2(nh.ca.tm.k_a, nh.ca.tm.kb_a, init_nh_ca_cyto, nh.ca.tm.k_b, nh.ca.tm.kb_b, nh.ca.mg.c_const) "calculated steady state at initial Ca2+ concentrations for nh.ca.tmc.f";
  parameter Real steady_nh_ca_f_tmm = buffSteady2(nh.ca.tm.k_b, nh.ca.tm.kb_b, nh.ca.mg.c_const, nh.ca.tm.k_a, nh.ca.tm.kb_a, init_nh_ca_cyto) "calculated steady state at initial Ca2+ concentrations for nh.ca.tmm.f";

  Boolean step_nh_ca_cyto = ca_low > init_nh_ca_cyto "step from false to true indicates time stamp where ca_low = init_nh_ca_cyto is achieved";
  Boolean step_nh_ca_sub = ca_low > init_nh_ca_sub "step from false to true indicates time stamp where ca_low = init_nh_ca_sub is achieved";
  Boolean step_nh_ca_jsr = ca_high > init_nh_ca_jsr "step from false to true indicates time stamp where ca_high = init_nh_ca_jsr is achieved";
  Boolean step_nh_ca_nsr = ca_high > init_nh_ca_nsr "step from false to true indicates time stamp where ca_high = init_nh_ca_nsr is achieved";

equation
  (temp_f, temp_f2) = buffSteady2(an.ca.tm.k_a, an.ca.tm.kb_a, ca_low, an.ca.tm.k_b, an.ca.tm.kb_b, an.ca.mg.c_const);
  connect(an.p, vc_an.p);
  connect(an.n, vc_an.n);
  connect(n.p, vc_n.p);
  connect(n.n, vc_n.n);
  connect(nh.p, vc_nh.p);
  connect(nh.n, vc_nh.n);
  connect(sim_buff_ca_cyto.substance, sim_buff_tc.site);
  connect(sim_buff_ca_cyto.substance, sim_buff_tm.site_a);
  connect(sim_buff_mg.substance, sim_buff_tm.site_b);
  der(v) = 0.2;
  der(ca_low) = 1e-3;
  der(ca_high) = 1.5;
  // |(an|n|nh)\.(na|cal|to|kr|hcn|st)\.(act|inact).*
annotation(
  Documentation(info="<html>
    <p>This model is a sloppy implementation of multiple invidivual simulations
    to test whether the initial values for the AN, N, and NH cell models given
    in Inada 2009 correspond to true steady states.</p>
    <p>It includes both the full cell models for all three cell types, whose
    voltage is held constant at the initial value, and separate variables and
    components, which calculate the true steady states at voltage v, which
    rises linearly throughout the simulation.
    For steady states of components of the Ca2+-handling, two similar linear
    functions are introduced for low Ca2+ concentrations: <code>ca_low</code>
    for [Ca2+]_sub and [Ca2+]_cyto; and <code>ca_high</code> for [Ca2+]_jsr
    and [Ca2+]_nsr.</p>
    <p>The individual experiments that can be performed with this model are
    the following:</p>
    <ul>
      <li>Plot a difference variable whose name starts with <code>an_</code>,
      <code>n_</code>, or <code>nh_</code> together with the corresponding
      <code>step_an_</code>, <code>step_n_</code> or <code>step_nh_</code>
      variable against time.
      If the initial values for this variable form a true steady state, the
      difference variable should have a zero crossing at exactly the point in
      time where the step variable switches from false to true.
      If this is not the case, but the initial values form a steady state at
      some other voltage or concentration, all difference variables of that
      cell type should have their zero crossing at exactly the same position.
      </li>
      <li>Plot any of the variables starting with <code>sim_</code> against
      time.
      If the initial values for the corresponding cell type are at a true
      steady state, the plot should be a flat zero line.
      If this is not the case, one can assert whether the steady state
      functions used in this model are correct by looking at the asymptotic
      behavior.
      For long simulations, the variable should always approach zero.
      The time it takes to &quot;reach&quot; zero (within a certain tolerance)
      from a non-steady state can also be used as indicator how long a
      simulation for the corresponding component must be run to obtain the
      steady state.
      </li>
    </ul>
    <p>Simulation protocol and parameters are chosen with the following
    rationale:</p>
    <ul>
      <li>StopTime: allow a plot covering all plausible ranges (
        v from -100 to +900 mV, ca_low from 0 to 5e-3 mM,
        ca_high from 0 to 7.5 mV)</li>
      <li>Tolerance: default value</li>
      <li>Interval: enough for a smooth plot</li>
      <li>Initial values: taken from Inada 2009</li>
    </ul>
  </htmL>"),
  experiment(StartTime = 0, StopTime = 5, Tolerance = 1e-6, Interval = 0.01),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="(an|n|nh|step)_.*")
);
end SteadyStates;

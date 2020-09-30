within InaMo.Examples;
model SteadyStates "calculates steady states at different voltages"
  // used to determine whether starting values in C++/CellML correlate to steady states
  // NOTE: I_na, I_Ca,L - seems like slow inactivation is not at steady state, but rest is
  // NOTE: I_to - only act is at steady state
  // NOTE: I_K,r - only inact is at steady state
  import InaMo.Components.ExperimentalMethods.VoltageClamp;
  VoltageClamp vc(v_stim = v);
  ANCell an(l2.use_init=false);
  NCell n(l2.use_init=false);
  NHCell nh(l2.use_init=false);
  SI.Voltage v(start=-0.1, fixed=true);
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
equation
  connect(an.p, vc.p);
  connect(an.n, vc.n);
  connect(n.p, vc.p);
  connect(n.n, vc.n);
  connect(nh.p, vc.p);
  connect(nh.n, vc.n);
  der(v) = 0.2;
end SteadyStates;

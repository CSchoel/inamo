within InaMo.Examples;
model SteadyStates "calculates steady states at different voltages"
  // used to determine whether starting values in C++/CellML correlate to steady states
  // NOTE: seems like slow inactivation is not at steady state, but rest is
  import InaMo.Components.ExperimentalMethods.VoltageClamp;
  VoltageClamp vc(v_stim = v);
  ANCell an(l2.use_init=false);
  NCell n(l2.use_init=false);
  NHCell nh(l2.use_init=false);
  SI.Voltage v(start=-0.1, fixed=true);
  parameter SI.Voltage an_v_init = -7.00E-02;
  parameter SI.Voltage n_v_init = -6.21E-02;
  parameter SI.Voltage nh_v_init = -6.86E-02;
  parameter Real an_na_act_init = 0.01227;
  parameter Real an_na_inact_fast_init = 0.717;
  parameter Real an_na_inact_slow_init = 0.6162;
  Real an_na_act = an.na.act.falpha(v) / (an.na.act.falpha(v) + an.na.act.fbeta(v)) - an_na_act_init;
  Real an_na_inact_fast = an.na.inact_fast.fsteady(v) - an_na_inact_fast_init;
  Real an_na_inact_slow = an.na.inact_slow.fsteady(v) - an_na_inact_slow_init;
  Real an_v_step = if v < an_v_init then 0 else 1;
  Real n_v_step = if v < n_v_init then 0 else 1;
  Real nh_v_step = if v < nh_v_init then 0 else 1;
equation
  connect(an.p, vc.p);
  connect(an.n, vc.n);
  connect(n.p, vc.p);
  connect(n.n, vc.n);
  connect(nh.p, vc.p);
  connect(nh.n, vc.n);
  der(v) = 0.2;
end SteadyStates;

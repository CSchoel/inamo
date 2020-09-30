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
  parameter SI.Voltage init_an_v = -7.00E-02;
  parameter SI.Voltage init_n_v = -6.21E-02;
  parameter SI.Voltage init_nh_v = -6.86E-02;
  parameter Real init_an_na_act = 0.01227;
  parameter Real init_an_na_inact_fast = 0.717;
  parameter Real init_an_na_inact_slow = 0.6162;
  Real an_na_act = an.na.act.falpha(v) / (an.na.act.falpha(v) + an.na.act.fbeta(v)) - init_an_na_act;
  Real an_na_inact_fast = an.na.inact_fast.fsteady(v) - init_an_na_inact_fast;
  Real an_na_inact_slow = an.na.inact_slow.fsteady(v) - init_an_na_inact_slow;
  Real an_v_step = if v < init_an_v then 0 else 1;
  Real n_v_step = if v < init_n_v then 0 else 1;
  Real nh_v_step = if v < init_nh_v then 0 else 1;
equation
  connect(an.p, vc.p);
  connect(an.n, vc.n);
  connect(n.p, vc.p);
  connect(n.n, vc.n);
  connect(nh.p, vc.p);
  connect(nh.n, vc.n);
  der(v) = 0.2;
end SteadyStates;

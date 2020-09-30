within InaMo.Examples;
model SteadyStates "calculates steady states at different voltages"
  // used to determine whether starting values in C++/CellML correlate to steady states
  import InaMo.Components.ExperimentalMethods.VoltageClamp;
  VoltageClamp vc(v_stim = v);
  ANCell an(l2.use_init=false);
  NCell n(l2.use_init=false);
  NHCell nh(l2.use_init=false);
  SI.Voltage v(start=-0.1, fixed=true);
  parameter SI.Voltage v_init = -0.06863;
  parameter Real n_na_act_init = 0.01529;
  Real n_na_act = an.na.act.falpha(v) / (an.na.act.falpha(v) + an.na.act.fbeta(v)) - n_na_act_init;
  Real v_step = if v < v_init then 0 else 1;
equation
  connect(an.p, vc.p);
  connect(an.n, vc.n);
  connect(n.p, vc.p);
  connect(n.n, vc.n);
  connect(nh.p, vc.p);
  connect(nh.n, vc.n);
  der(v) = 0.2;
end SteadyStates;

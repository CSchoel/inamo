within InaMo.Examples;
model LTypeCalcium
  LipidBilayer l2(use_init=false);
  VoltageClamp vc;
  LTypeCalciumChannel cal;
  LTypeCalciumChannelN calN;
  ConstantConcentration ca(c_const=0);
  Real act_steady = cal.act.fsteady(v);
  Real act_steady_n = calN.act.fsteady(v);
  Real act_tau = cal.act.tau;
  Real inact_steady = cal.inact_slow.fsteady(v);
  Real inact_tau_fast = cal.inact_fast.ftau(v);
  Real inact_tau_slow = cal.inact_slow.ftau(v);
  SI.Voltage v(start=-0.08, fixed=true);
equation
  vc.v_stim = v;
  der(v) = 0.001;
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(l2.p, cal.p);
  connect(l2.n, cal.n);
  connect(l2.p, calN.p);
  connect(l2.n, calN.n);
  connect(ca.c, cal.c_sub);
  connect(ca.c, calN.c_sub);
end LTypeCalcium;

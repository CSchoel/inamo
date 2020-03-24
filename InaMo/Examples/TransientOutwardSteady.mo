within InaMo.Examples;
model TransientOutwardSteady
  LipidBilayer l2(use_init=false);
  VoltageClamp vc;
  TransientOutwardChannel to;
  Real act_steady = to.act.fsteady(v);
  Real act_tau = to.act.ftau(v);
  Real inact_steady = to.inact_slow.fsteady(v);
  Real inact_tau_fast = to.inact_fast.ftau(v);
  Real inact_tau_slow = to.inact_slow.ftau(v);
  SI.Voltage v(start=-0.08, fixed=true);
equation
  vc.v_stim = v;
  der(v) = 0.001;
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(l2.p, to.p);
  connect(l2.n, to.n);
end TransientOutwardSteady;

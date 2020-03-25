within InaMo.Examples;
model RapidDelayedRectifierSteady
  LipidBilayer l2(use_init=false);
  VoltageClamp vc;
  RapidDelayedRectifierChannel kr;
  Real act_steady = kr.act_fast.fsteady(v);
  Real act_tau_fast = kr.act_fast.tau;
  Real act_tau_slow = kr.act_slow.ftau(v);
  SI.Voltage v(start=-0.12, fixed=true);
equation
  vc.v_stim = v;
  der(v) = 0.001;
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(l2.p, kr.p);
  connect(l2.n, kr.n);
end RapidDelayedRectifierSteady;

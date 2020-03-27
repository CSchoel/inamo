within InaMo.Examples;
model HyperpolarizationActivatedSteady
  LipidBilayer l2(use_init=false);
  VoltageClamp vc;
  HyperpolarizationActivatedChannel f;
  Real act_steady = f.act.fsteady(v);
  Real act_tau = f.act.ftau(v);
  SI.Voltage v(start=-0.12, fixed=true);
equation
  vc.v_stim = v;
  der(v) = 0.001;
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(l2.p, f.p);
  connect(l2.n, f.n);
end HyperpolarizationActivatedSteady;

within InaMo.Examples;
model SustainedOutwardSteady
  LipidBilayer l2(use_init=false);
  VoltageClamp vc;
  SustainedOutwardChannel st;
  Real act_steady = st.act.fsteady(v);
  Real act_tau = st.act.ftau(v);
  Real inact_steady = inact_tau * st.inact.falpha(v);
  Real inact_tau = 1 / (st.inact.falpha(v) + st.inact.fbeta(v));
  SI.Voltage v(start=-0.06, fixed=true);
equation
  vc.v_stim = v;
  der(v) = 0.001;
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(l2.p, st.p);
  connect(l2.n, st.n);
end SustainedOutwardSteady;

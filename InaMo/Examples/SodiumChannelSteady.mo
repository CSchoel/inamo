within InaMo.Examples;
model SodiumChannelSteady "try tro recreate figure 2 A from lindblad 1997"
  SodiumChannel na(
    ion=sodium,
    T=T
  );
  LipidBilayer l2(use_init=false);
  // Note: uses Lindblad parameters instead of Inada parameters MobileIon(8, 140, 1.4e-9, 1), 310K
  parameter MobileIon sodium = MobileIon(8.4, 75, 1.4e-9*1.5, 1);
  parameter Real T = SI.Conversions.from_degC(35);
  VoltageClamp vc(v_stim(start=-0.1, fixed=true));
  parameter SI.Duration T_step = 2;
  parameter SI.Voltage v_step = 0.005;
  discrete Real m3(start=0, fixed=true);
  discrete Real h_total(start=0, fixed=true);
  Real m_steady = na.activation.falpha(vc.v_stim)
    / (na.activation.falpha(vc.v_stim) + na.activation.fbeta(vc.v_stim));
  Real h_steady = na.inact_fast.n_steady;
  // TODO investigate why tau_m and tau_m_act differ by a factor of 10
  discrete Real tau_m = 1 / (na.activation.falpha(vc.v_stim) + na.activation.fbeta(vc.v_stim));
  discrete Real tau_m_act(start=0, fixed=true);
  discrete Real tau_h1 = na.inact_fast.ftau(vc.v_stim);
  discrete Real tau_h2 = na.inact_slow.ftau(vc.v_stim);
  discrete Real t_tau_m(start=0, fixed=true);
  Real v_na =  nernst(sodium, l2.T_m);
equation
  connect(l2.p, na.p);
  connect(l2.n, na.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);

  when (abs(m_steady - na.activation.n) < 1e-6) then
    tau_m_act = time - pre(t_tau_m);
  end when;

  when sample(0, T_step) then
    // reset stimulation voltage
    reinit(vc.v_stim, pre(vc.v_stim) + v_step);
    // record values from last cycle
    m3 = pre(na.activation.n)^3;
    h_total = pre(na.inact_total);
    t_tau_m = time;
  end when;
  der(vc.v_stim) = 0; // hold v_stim constant
annotation(
  experiment(StartTime = 0, StopTime = 80, Tolerance = 1e-6, Interval = 1e-2),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To reproduce Figure 2A from Lindblad 1997, plot m3 against
      (v_stim - v_inc) and h_total against v_stim.</p>
      <p>To reproduce Figure 2B from Lindblad 1997, plot i against
      (v_stim - v_inc).</p>
      <p>Note that results will not be exact as Lindblad 1997 used the full
      model to generate the plots. Also we use the parameter settings from
      Inada 2009 for sodium and T and for figure 2B we plot current and
      not current density.</p>
    </html>
  ")
);
end SodiumChannelSteady;

within InaMo.Examples;
model SodiumChannelSteady "try tro recreate figure 2 A, C, D and E from lindblad 1997"
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
  Real m3_steady = m_steady ^ 3;
  Real h_steady = na.inact_fast.n_steady;
  discrete Real tau_m = 1 / (na.activation.falpha(vc.v_stim) + na.activation.fbeta(vc.v_stim));
  discrete Real tau_m_measured(start=0, fixed=true) "measured time until difference between na.activation.n and m_stead is < 1e-6";
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
    tau_m_measured = time - pre(t_tau_m);
  end when "forces event when steady state is almost reached";

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
      (v_stim - v_inc) and h_total against vc.v_stim.</p>
      <p>To reproduce Figure 2C-E, plot tau_m, tau_h1, and tau_h2
      respectively against v_stim.</p>
      <p>Results should be fully accurate.</p>
      <p>Note: This model could be much simpler if we would only
      calculate the steady states. However, this setup allows to actually
      inspect the time course of the variables to see when they will reach
      their steady state. Since the parameter n of the activation gate has a
      very low time constant (10-65 μs), the default experiment setup will
      only let you see the point in time where the steady state is almost
      reached. If you want more detail, you will have to decrease the
      simulation interval at least to 1e-4 (i.e. 100 μs).</p>
    </html>
  ")
);
end SodiumChannelSteady;
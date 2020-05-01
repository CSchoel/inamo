within InaMo.Examples;
model SodiumChannelSteady "steady state of I_Na, recreates Figures 2A, 2C, 2D and 2E from Lindblad 1997"
  SodiumChannel na(
    ion=sodium
  );
  LipidBilayer l2(use_init=false);
  inner parameter SI.Temperature T=SI.Conversions.from_degC(35);
  // Note: uses Lindblad parameters instead of Inada parameters MobileIon(8, 140, 1.4e-9, 1), 310K
  parameter MobileIon sodium = MobileIon(8.4, 75, 1.4e-9*1.5, 1);
  VoltageClamp vc(v_stim(start=-0.1, fixed=true));
  parameter SI.Duration T_step = 2;
  parameter SI.Voltage v_step = 0.005;
  discrete Real m3(start=0, fixed=true);
  discrete Real h_total(start=0, fixed=true);
  Real m_steady = na.activation.falpha(vc.v_stim)
    / (na.activation.falpha(vc.v_stim) + na.activation.fbeta(vc.v_stim));
  Real m3_steady = m_steady ^ 3;
  Real h_steady = na.inact_fast.fsteady(vc.v_stim);
  discrete Real tau_m = 1 / (na.activation.falpha(vc.v_stim) + na.activation.fbeta(vc.v_stim));
  discrete Real tau_m_measured(start=0, fixed=true) "measured time until difference between na.activation.n and m_stead is < 1e-6";
  discrete Real tau_h1 = na.inact_fast.ftau(vc.v_stim);
  discrete Real tau_h2 = na.inact_slow.ftau(vc.v_stim);
  discrete Real t_tau_m(start=0, fixed=true);
  Real v_na =  nernst(sodium, T);
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
  der(vc.v_stim) = 0 "hold v_stim constant";
annotation(
  experiment(StartTime = 0, StopTime = 82, Tolerance = 1e-12, Interval = 1e-2),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __ChrisS_testing(testedVariableFilter="m3_steady|h_steady|m3|vc\\.(v_sim|v)|v_step|h_total|tau_(m|h1|h2)"),
  Documentation(info="
    <html>
      <p>To reproduce Figure 2A from Lindblad 1997, plot m3 against
      (vc.v_stim - v_step) and h_total against vc.v_stim.</p>
      <p>To reproduce Figure 2C-E, plot tau_m, tau_h1, and tau_h2
      respectively against vc.v_stim.</p>
      <p>Results should be fully accurate.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -100 mV to 100 mV</li>
        <li>Tolerance: detect changes of a single picoampere</li>
        <li>Interval: enough to get correct peak values, but to follow time
        course of current at least an interval of 1e-4 s is needed</li>
      </ul>
      <p>NOTE: This model could be much simpler if we would only
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

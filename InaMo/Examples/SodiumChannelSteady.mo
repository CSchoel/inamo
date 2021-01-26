within InaMo.Examples;
model SodiumChannelSteady "steady state of I_Na, recreates Figures 2A, 2C, 2D and 2E from Lindblad 1996"
  extends Modelica.Icons.Example;
  InaMo.Components.IonCurrents.SodiumChannel na
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  InaMo.Components.LipidBilayer l2(use_init=false)
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
  // Note: uses Lindblad parameters instead of Inada parameters (8, 140, 1.4e-9, 1), 310K
  inner parameter SI.Temperature temp=SI.Conversions.from_degC(35);
  inner parameter SI.Concentration na_in = 8.4;
  inner parameter SI.Concentration na_ex = 75;
  inner parameter PermeabilityFM na_p = 1.4e-9*1.5;
  InaMo.ExperimentalMethods.VoltageClamp.VoltageClamp vc(v_stim(start=-0.1, fixed=true))
    annotation(Placement(transformation(extent={{-17, -17}, {17, 17}})));
  parameter SI.Duration d_step = 2;
  parameter SI.Voltage v_step = 0.005;
  discrete Real m3(start=0, fixed=true);
  discrete Real h_total(start=0, fixed=true);
  Real m_steady = na.act.alpha / (na.act.alpha + na.act.beta);
  Real m3_steady = m_steady ^ 3;
  Real h_steady = na.inact_fast.steady;
  Real tau_m = na.act.tau;
  Real tau_m_measured(start=0, fixed=true) "measured time until difference between na.act.n and m_stead is < 1e-6";
  Real tau_h1 = na.inact_fast.tau;
  Real tau_h2 = na.inact_slow.tau;
  Real t_tau_m(start=0, fixed=true);
  Real v_na =  nernst(na_in, na_ex, 1, temp);
equation
  connect(l2.p, vc.p) annotation(
    Line(points = {{34, 18}, {34, 18}, {34, 40}, {0, 40}, {0, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(vc.p, na.p) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 40}, {-34, 40}, {-34, 18}, {-34, 18}}, color = {0, 0, 255}));
  connect(l2.n, vc.n) annotation(
    Line(points = {{34, -16}, {34, -16}, {34, -40}, {0, -40}, {0, -16}, {0, -16}}, color = {0, 0, 255}));
  connect(vc.n, na.n) annotation(
    Line(points = {{0, -16}, {0, -16}, {0, -40}, {-34, -40}, {-34, -16}, {-34, -16}}, color = {0, 0, 255}));
  when (abs(m_steady - na.act.n) < 1e-6) then
    tau_m_measured = time - pre(t_tau_m);
  end when "forces event when steady state is almost reached";

  when sample(0, d_step) then
    // reset stimulation voltage
    reinit(vc.v_stim, pre(vc.v_stim) + v_step);
    // record values from last cycle
    m3 = pre(na.act.n)^3;
    h_total = pre(na.inact_total);
    t_tau_m = time;
  end when;
  der(vc.v_stim) = 0 "hold v_stim constant";
annotation(
  experiment(StartTime = 0, StopTime = 82, Tolerance = 1e-6, Interval = 1e-2),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="m3_steady|h_steady|m3|vc\\.(v_sim|v)|v_step|h_total|tau_(m|h1|h2)"),
  Documentation(info="
    <html>
      <p>To reproduce Figure 2A from Lindblad 1996, plot m3 against
      (vc.v_stim - v_step) and h_total against vc.v_stim.</p>
      <p>To reproduce Figure 2C-E, plot tau_m, tau_h1, and tau_h2
      respectively against vc.v_stim.</p>
      <p>Results should be fully accurate.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -100 mV to 100 mV</li>
        <li>Tolerance: default value</li>
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

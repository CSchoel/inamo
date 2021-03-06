within InaMo.Examples.ComponentTests;
model SustainedInwardIV "IV relationship of I_st, recreates Figure S5B and S5C of Inada 2009"
  extends InaMo.Examples.Interfaces.IVBase(
    vc(v_hold=-0.08, d_hold=15, d_pulse=0.5),
    v_start = -0.08,
    v_inc = 0.005
  );
  extends Modelica.Icons.Example;
  InaMo.Currents.Atrioventricular.SustainedInwardChannel st(g_max=0.27e-9) "I_st"
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  InaMo.Membrane.LipidBilayer l2(use_init=false, c=29e-12) "cell membrane"
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
equation
  connect(l2.p, vc.p) annotation(
    Line(points = {{34, 18}, {34, 18}, {34, 40}, {0, 40}, {0, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(vc.p, st.p) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 40}, {-34, 40}, {-34, 18}, {-34, 18}}, color = {0, 0, 255}));
  connect(l2.n, vc.n) annotation(
    Line(points = {{34, -16}, {34, -16}, {34, -40}, {0, -40}, {0, -16}, {0, -16}}, color = {0, 0, 255}));
  connect(vc.n, st.n) annotation(
    Line(points = {{0, -16}, {0, -16}, {0, -40}, {-34, -40}, {-34, -16}, {-34, -16}}, color = {0, 0, 255}));
annotation(
  experiment(StartTime = 0, StopTime = 480, Tolerance = 1e-6, Interval = 1e-2),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="vc\\.(is_peak|vs_peak|i|v|v_pulse)"),
  Documentation(info="
    <html>
    <p>To reproduce Figure S5B from Inada 2009, plot vc.i against time
    starting 50 ms before and ending 100 ms after the pulses with amplitude
    -80 to 60 mV (in 10 mV increments).</p>
    <p>To reproduce Figure S5C from Inada 2009, plot vc.is_peak against
    vc.vs_peak.
    It is necessary to use vc.vs_peak instead of vc.v_pulse,
    because vc.is_peak captures the current from the <i>previous</i> pulse.</p>
    <p>Simulation protocol and parameters are chosen with the following
    rationale:</p>
    <ul>
      <li>StopTime: allow a plot from -80 mV to 60 mV</li>
      <li>Tolerance: default value</li>
      <li>d_pulse: according to description of Figure S5 in Inada 2009</li>
      <li>d_hold: approximately 5 * max(inact.tau)</li>
      <li>v_hold: according to description of Figure S5 in Inada 2009</li>
      <li>l2.C: according to Table S15 in Inada 2009 (N cell model)</li>
      <li>st.g_max: manually adjusted, because it gives better agreement
      with both Figures S5B and S5C (see note below)</li>
    </ul>
    <p>NOTE: The value for g_max had to be adjusted to obtain
    current densities that are comparable to those in Figure S5B and S5C in
    Inada 2009.
    This is probably because Inada et al. fitted the model to experimental
    data without stating this in the figure description.</p>
    </html>
  ")
);
end SustainedInwardIV;

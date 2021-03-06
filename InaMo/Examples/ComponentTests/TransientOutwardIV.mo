within InaMo.Examples.ComponentTests;
model TransientOutwardIV "IV relationship of I_to, recreates Figures S2E and S2F from Inada 2009"
  extends Modelica.Icons.Example;
  extends InaMo.Examples.Interfaces.IVBase(
    vc(v_hold=-0.08, d_hold=20, d_pulse=0.5),
    v_start = -0.06,
    v_inc = 0.005
  );
  parameter SI.Concentration k_in = 140 "intracellular potassium concentration";
  parameter SI.Concentration k_ex = 5.4 "extracellular potassium concentration";
  parameter SI.Temperature temp = 310 "cell medium temperature";
  parameter SI.Voltage v_k = nernst(k_in, k_ex, 1, temp) "equilibrium potential for K+ ions";
  InaMo.Currents.Atrioventricular.TransientOutwardChannel to(g_max=14e-9, v_eq =v_k) // use g_max of NH model
    "I_to (parameter values for NH cell)"
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  InaMo.Membrane.LipidBilayer l2(use_init=false, c=40e-12) "cell membrane"
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
equation
  connect(l2.p, vc.p) annotation(
    Line(points = {{34, 18}, {34, 18}, {34, 40}, {0, 40}, {0, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(vc.p, to.p) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 40}, {-34, 40}, {-34, 18}, {-34, 18}}, color = {0, 0, 255}));
  connect(l2.n, vc.n) annotation(
    Line(points = {{34, -16}, {34, -16}, {34, -40}, {0, -40}, {0, -16}, {0, -16}}, color = {0, 0, 255}));
  connect(vc.n, to.n) annotation(
    Line(points = {{0, -16}, {0, -16}, {0, -40}, {-34, -40}, {-34, -16}, {-34, -16}}, color = {0, 0, 255}));
annotation(
  experiment(StartTime = 0, StopTime = 532.5, Tolerance = 1e-6, Interval = 1e-2),
  __MoST_experiment(variableFilter="vc\\.(i|is_peak|vs_peak|v|v_pulse)"),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
    <p>To reproduce Figure S2E from Inada 2009, plot vc.i against time for
    500 ms after the pulses with amplitude -10, 0, 20 and 40 mV.</p>
    <p>To reproduce Figure S2F from Inada 2009, plot vc.is_peak/max(vc.is_peak)
    against vc.vs_peak.
    It is necessary to use vc.vs_peak instead of vc.v_pulse,
    because vc.is_peak captures the current from the <i>previous</i> pulse.</p>
    <p>Simulation protocol and parameters are chosen with the following
    rationale:</p>
    <ul>
      <li>StopTime: allow a plot from -60 mV to 60 mV (NOTE: It is important
      to choose StopTime such that the pulse for 65 mV is not part of the
      simulation, because otherwise the normalized current would change, since
      the maximum current is achieved during the last pulse)</li>
      <li>Tolerance: default value</li>
      <li>Interval: enough to roughly plot time course of current</li>
      <li>d_pulse: according to description of Figure S2 in Inada 2009</li>
      <li>d_hold: approximately 5 * max(inact_slow.tau)</li>
      <li>v_hold: according to description of Figure S2 in Inada 2009</li>
      <li>l2.C: according to Table S15 in Inada 2009 (NH cell model)</li>
      <li>to.g_max: according to Table S15 in Inada 2009 (NH cell model)</li>
    </ul>
    <p>NOTE: Although Inada et al. state that they used the AN cell model for
    Figure S2E and S2F, the absolute values of the current make it seem more
    likely, that the NH cell model was used instead.
    However, with these parameters the model still shows too high absolute
    values for the current.
    We see two possible explanations for this difference: Either Inada et al.
    used differnet parameter settings for the plots without documenting them
    or they chose d_hold too small, so that recovery to the steady state at
    holding potential was not completed before the next pulse.
    The difference disappears when the current is multiplied by a factor of
    0.75 (e.g. by adjusting g_max).</p>
    </html>
  ")
);
end TransientOutwardIV;

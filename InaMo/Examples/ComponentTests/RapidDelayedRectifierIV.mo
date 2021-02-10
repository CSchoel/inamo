within InaMo.Examples.ComponentTests;
model RapidDelayedRectifierIV "IV relationship of I_K,r, recreates Figure S3C-S3E"
  extends InaMo.Examples.Interfaces.IVBase(
    vc(v_hold=-0.04, d_hold=5, d_pulse=0.5),
    v_start = -0.04,
    v_inc = 0.005
  );
  extends Modelica.Icons.Example;
  parameter SI.Concentration k_in = 140 "intracellular potassium concentration";
  parameter SI.Concentration k_ex = 5.4 "extracellular potassium concentration";
  parameter SI.Temperature temp = 310 "cell medium temperature";
  parameter SI.Voltage v_k = nernst(k_in, k_ex, 1, temp) "equilibrium potential for K+ ions";
  InaMo.Currents.Atrioventricular.RapidDelayedRectifierChannel kr(g_max=1.5e-9, v_eq=v_k) "I_K,r channel with parameters of AN cell model"
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  InaMo.Membrane.LipidBilayer l2(use_init=false, c=40e-12) "cell membrane"
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
equation
  connect(l2.p, vc.p) annotation(
    Line(points = {{34, 18}, {34, 18}, {34, 40}, {0, 40}, {0, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(vc.p, kr.p) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 40}, {-34, 40}, {-34, 18}, {-34, 18}}, color = {0, 0, 255}));
  connect(l2.n, vc.n) annotation(
    Line(points = {{34, -16}, {34, -16}, {34, -40}, {0, -40}, {0, -16}, {0, -16}}, color = {0, 0, 255}));
  connect(vc.n, kr.n) annotation(
    Line(points = {{0, -16}, {0, -16}, {0, -40}, {-34, -40}, {-34, -16}, {-34, -16}}, color = {0, 0, 255}));
annotation(
  experiment(StartTime = 0, StopTime = 126, Tolerance = 1e-12, Interval = 1e-2),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="vc\\.(is_end|vs_end|is_tail|vs_tail|is_peak|vs_peak|i|v|v_pulse)"),
  Documentation(info="
    <html>
    <p>To reproduce Figure S3C from Inada 2009, plot vc.is_end against
    vc.vs_end.
    To reproduce Figure S3D from Inada 2009, plot vc.is_tail against
    vc.vs_tail.
    It is necessary to use vc.vs_end/vc.vs_tail instead of vc.v_pulse,
    because vc.is_end and vc.is_tail capture the current from the
    <i>previous</i> pulse.</p>
    <p>To reproduce Figure S3E from Inada 2009, plot vc.i against time starting
    5 ms before and ending 500ms after the pulses with amplitude -10 mV, 10 mV
    and 30 mV.</p>
    <p>Simulation protocol and parameters are chosen with the following
    rationale:</p>
    <ul>
      <li>StopTime: allow a plot from -40 mV to 60 mV</li>
      <li>Tolerance: default value</li>
      <li>d_pulse: according to description of Figure S3 in Inada 2009</li>
      <li>d_hold: approximately 5 * max(inact.tau)</li>
      <li>v_hold: according to description of Figure S3 in Inada 2009</li>
      <li>l2.C: according to Table S15 in Inada 2009 (AN cell model)</li>
      <li>g_max: according to Table S15 in Inada 2009 (AN cell model)</li>
    </ul>
    <p>NOTE: IV-curve in S3C seem to be shifted by 5 mV towards lower
    voltages.
    This could be explained if Inada et al. accidentally associated currents
    with the newly started pulse right after the current was measured instead
    of the previous pulse.</p>
  ")
);
end RapidDelayedRectifierIV;

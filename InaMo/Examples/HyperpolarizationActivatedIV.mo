within InaMo.Examples;
model HyperpolarizationActivatedIV "IV relationship of I_f, recreates Figures S4C and S4D from Inada 2009"
  extends IVBase(
    vc(v_hold=-0.05, d_hold=20, d_pulse=4),
    v_start = -0.12,
    v_inc = 0.005
  );
  extends Modelica.Icons.Example;
  extends InaMo.Interfaces.NoACh;
  InaMo.Components.IonCurrents.HyperpolarizationActivatedChannel f
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  InaMo.Components.LipidBilayer l2(use_init=false, c=29e-12)
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
equation
  connect(l2.p, vc.p) annotation(
    Line(points = {{34, 18}, {34, 18}, {34, 40}, {0, 40}, {0, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(vc.p, f.p) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 40}, {-34, 40}, {-34, 18}, {-34, 18}}, color = {0, 0, 255}));
  connect(l2.n, vc.n) annotation(
    Line(points = {{34, -16}, {34, -16}, {34, -40}, {0, -40}, {0, -16}, {0, -16}}, color = {0, 0, 255}));
  connect(vc.n, f.n) annotation(
    Line(points = {{0, -16}, {0, -16}, {0, -40}, {-34, -40}, {-34, -16}, {-34, -16}}, color = {0, 0, 255}));
annotation(
  experiment(StartTime = 0, StopTime = 404, Tolerance = 1e-6, Interval = 1e-1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="vc\\.(is_end|vs_end|i|v|v_pulse)"),
  Documentation(info="
    <html>
      <p>To reproduce Figure S4C from Inada 2009, plot vc.is_end against
      vc.vs_end.
      It is necessary to use vc.vs_end instead of vc.v_pulse, because cd
      captures the current density from the <i>previous</i> pulse.</p>
      <p>For Figure S4D plot vc.i for 6 seconds following the start of
      the pulses with amplitude -120 to -60 mV.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -120 mV to -50 mv</li>
        <li>Tolerance: default value</li>
        <li>Interval: enough to roughly follow time course of current</li>
        <li>d_pulse: according to the description of Figure S4 in Inada 2009</li>
        <li>d_hold: approximately 5 * max(act.tau)</li>
        <li>l2.C: according to Table S15 in Inada 2009 (N cell model)</li>
      </ul>
      <p>We assume the parameter values for the N cell model since I_f is
      only present in N cells.</p>
    </html>
  ")
);
end HyperpolarizationActivatedIV;

within InaMo.Examples.ComponentTests;
model TransientOutwardSteady "steady state of I_to, recreates Figures S2A-S2D from Inada 2009"
  extends Modelica.Icons.Example;
  InaMo.Membrane.LipidBilayer l2(use_init=false) "cell membrane"
    annotation(Placement(transformation(extent={{-17,-17},{17,17}})));
  InaMo.ExperimentalMethods.VoltageClamp.VoltageClamp vc "voltage clamp"
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
  InaMo.Currents.Atrioventricular.TransientOutwardChannel to(v_eq=v_k) "I_to"
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  parameter SI.Concentration k_in = 140 "intracellular potassium concentration";
  parameter SI.Concentration k_ex = 5.4 "extracellular potassium concentration";
  parameter SI.Temperature temp = 310 "cell medium temperature";
  parameter SI.Voltage v_k = nernst(k_in, k_ex, 1, temp) "equilibrium potential for K+ ions";
  Real act_steady = to.act.steady "steady state of activation gate";
  SI.Duration act_tau = to.act.tau "time constant of activation gate";
  Real inact_steady = to.inact_slow.steady "steady state of inactivation gates";
  SI.Duration inact_tau_fast = to.inact_fast.tau "time constant of fast inactivation gate";
  SI.Duration inact_tau_slow = to.inact_slow.tau "time constant of slow inactivation gate";
  SI.Voltage v(start=-0.12, fixed=true);
equation
  vc.v_stim = v;
  der(v) = 0.001;
  connect(to.p, l2.p) annotation(
    Line(points = {{-34, 18}, {-34, 18}, {-34, 28}, {0, 28}, {0, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(l2.p, vc.p) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 28}, {34, 28}, {34, 18}, {34, 18}}, color = {0, 0, 255}));
  connect(to.n, l2.n) annotation(
    Line(points = {{-34, -16}, {-34, -16}, {-34, -28}, {0, -28}, {0, -16}, {0, -16}}, color = {0, 0, 255}));
  connect(l2.n, vc.n) annotation(
    Line(points = {{0, -16}, {0, -16}, {0, -28}, {34, -28}, {34, -16}, {34, -16}}, color = {0, 0, 255}));
annotation(
  experiment(StartTime = 0, StopTime = 200, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="act_tau|act_steady|inact_steady|inact_tau_fast|inact_tau_slow|v|vc\\.v"),
  Documentation(info="
    <html>
      <p>To reproduce Figure S2A-S2D from Inada 2009, plot act_steady,
      inact_steady, inact_tau_fast and inact_tau_slow against v.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -120 to 80 mV</li>
        <li>Tolerance: left at default value, since derivatives are not
        relevant</li>
        <li>Interval: enough to give a smooth plot</li>
      </ul>
      <p>NOTE: Figure S2D shows a higher minimum for inact_slow.ftau.y_min
      (0.2 s instead of 0.1 s), but the formulas both in Inada 2009 and in
      the C++ code use the value of 0.1 s, which is why we keep it.</p>
    </html>
  ")
);
end TransientOutwardSteady;

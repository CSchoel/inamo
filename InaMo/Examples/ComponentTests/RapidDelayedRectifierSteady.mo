within InaMo.Examples.ComponentTests;
model RapidDelayedRectifierSteady "steady state of I_K,r, recreates figure S3A and S3B from Inada 2009"
  extends Modelica.Icons.Example;
  InaMo.Membrane.LipidBilayer l2(use_init=false) "cell membrane"
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
  InaMo.ExperimentalMethods.VoltageClamp.VoltageClamp vc "voltage clamp"
    annotation(Placement(transformation(extent={{-17, -17}, {17, 17}})));
  parameter SI.Concentration k_in = 140 "intracellular potassium concentration";
  parameter SI.Concentration k_ex = 5.4 "extracellular potassium concentration";
  parameter SI.Temperature temp = 310 "cell medium temperature";
  parameter SI.Voltage v_k = nernst(k_in, k_ex, 1, temp) "equilibrium potential for K+ ions";
  InaMo.Currents.Atrioventricular.RapidDelayedRectifierChannel kr(g_max=1.5e-9, v_eq=v_k)
    "I_K,r with parameters of AN cell model"
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  Real act_steady = kr.act_fast.steady "steady state of activation gates";
  SI.Duration act_tau_fast = kr.act_fast.tau "time constant of fast activation gate";
  SI.Duration act_tau_slow = kr.act_slow.tau "time constant of slow activation gate";
  Real inact_steady = kr.inact.steady "steady state of inactivation gate";
  SI.Duration inact_tau = kr.inact.tau "time constant of inactivation gate";
  SI.Voltage v(start=-0.12, fixed=true) "input voltage";
equation
  vc.v_stim = v;
  der(v) = 0.001;
  connect(l2.p, vc.p) annotation(
    Line(points = {{34, 18}, {34, 18}, {34, 40}, {0, 40}, {0, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(vc.p, kr.p) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 40}, {-34, 40}, {-34, 18}, {-34, 18}}, color = {0, 0, 255}));
  connect(l2.n, vc.n) annotation(
    Line(points = {{34, -16}, {34, -16}, {34, -40}, {0, -40}, {0, -16}, {0, -16}}, color = {0, 0, 255}));
  connect(vc.n, kr.n) annotation(
    Line(points = {{0, -16}, {0, -16}, {0, -40}, {-34, -40}, {-34, -16}, {-34, -16}}, color = {0, 0, 255}));
annotation(
  experiment(StartTime = 0, StopTime = 200, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="act_steady|act_tau_fast|v|act_tau_slow|inact_tau|inact_steady|vc.v"),
  Documentation(info="
    <html>
      <p>To reproduce Figure S3A and S3B from Inada 2009, plot act_steady and
      act_tau_fast against v.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -120 mV to 80 mV</li>
        <li>Tolerance: left at default value, since derivatives are not
        relevant</li>
      </ul>
    </html>
  ")
);
end RapidDelayedRectifierSteady;

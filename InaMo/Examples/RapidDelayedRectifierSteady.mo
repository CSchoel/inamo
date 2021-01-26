within InaMo.Examples;
model RapidDelayedRectifierSteady "steady state of I_K,r, recreates figure S3A and S3B from Inada 2009"
  extends Modelica.Icons.Example;
  InaMo.Components.LipidBilayer l2(use_init=false)
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
  InaMo.ExperimentalMethods.VoltageClamp.VoltageClamp vc
    annotation(Placement(transformation(extent={{-17, -17}, {17, 17}})));
  parameter SI.Concentration k_in = 140;
  parameter SI.Concentration k_ex = 5.4;
  parameter SI.Temperature temp = 310;
  parameter SI.Voltage v_k = nernst(k_in, k_ex, 1, temp);
  InaMo.Components.IonCurrents.RapidDelayedRectifierChannel kr(v_eq=v_k)
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  Real act_steady = kr.act_fast.steady;
  Real act_tau_fast = kr.act_fast.tau;
  Real act_tau_slow = kr.act_slow.tau;
  Real inact_steady = kr.inact.steady;
  Real inact_tau = kr.inact.tau;
  SI.Voltage v(start=-0.12, fixed=true);
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

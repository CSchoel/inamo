within InaMo.Examples;
model HyperpolarizationActivatedSteady "steady state of I_f, recreates Figures S4A and S4B from Inada 2009"
  extends Modelica.Icons.Example;
  extends InaMo.Interfaces.NoACh;
  InaMo.Components.LipidBilayer l2(use_init=false)
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
  InaMo.ExperimentalMethods.VoltageClamp.VoltageClamp vc
    annotation(Placement(transformation(extent={{-17, -17}, {17, 17}})));
  InaMo.Components.IonCurrents.HyperpolarizationActivatedChannel f
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  Real act_steady = f.act.steady;
  Real act_tau = f.act.tau;
  SI.Voltage v(start=-0.12, fixed=true);
equation
  vc.v_stim = v;
  der(v) = 0.001;
  connect(l2.p, vc.p) annotation(
    Line(points = {{34, 18}, {34, 18}, {34, 40}, {0, 40}, {0, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(vc.p, f.p) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 40}, {-34, 40}, {-34, 18}, {-34, 18}}, color = {0, 0, 255}));
  connect(l2.n, vc.n) annotation(
    Line(points = {{34, -16}, {34, -16}, {34, -40}, {0, -40}, {0, -16}, {0, -16}}, color = {0, 0, 255}));
  connect(vc.n, f.n) annotation(
    Line(points = {{0, -16}, {0, -16}, {0, -40}, {-34, -40}, {-34, -16}, {-34, -16}}, color = {0, 0, 255}));
annotation(
  experiment(StartTime = 0, StopTime = 80, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="act_steady|act_tau|v|vc.v"),
  Documentation(info="
    <html>
      <p>To reproduce Figure S4A from Inada 2009, plot act_steady against v.
      For Figure S4B, plot act_tau against v.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -120 to -40 mV</li>
        <li>Tolerance: left at default value, since derivatives are not
        relevant</li>
        <li>Interval: enough for a smooth plot</li>
      </ul>
    </html>
  ")
);
end HyperpolarizationActivatedSteady;

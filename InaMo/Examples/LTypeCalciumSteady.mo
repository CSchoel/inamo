within InaMo.Examples;
model LTypeCalciumSteady "steady state of I_Ca,L, recreates Figures S1A-S1D from Inada 2009"
  extends Modelica.Icons.Example;
  InaMo.Components.LipidBilayer l2(use_init=false)
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
  InaMo.Components.VoltageClamp vc
    annotation(Placement(transformation(extent={{-17, -17}, {17, 17}})));
  InaMo.Components.IonCurrents.LTypeCalciumChannel cal(ca_const=true)
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  InaMo.Components.IonCurrents.LTypeCalciumChannelN calN(ca_const=true)
    annotation(Placement(transformation(extent = {{-85, -17}, {-51, 17}})));
  InaMo.Components.IonConcentrations.ConstantConcentration ca(c_const=0)
    annotation(Placement(transformation(extent = {{-51, -80}, {-17, -46}})));
  Real act_steady = cal.act.fsteady(v);
  Real act_steady_n = calN.act.fsteady(v);
  Real act_tau = cal.act.ftau(v);
  Real inact_steady = cal.inact_slow.fsteady(v);
  Real inact_tau_fast = cal.inact_fast.ftau(v);
  Real inact_tau_slow = cal.inact_slow.ftau(v);
  SI.Voltage v(start=-0.08, fixed=true);
equation
  vc.v_stim = v;
  der(v) = 0.001;
  connect(l2.p, vc.p) annotation(
    Line(points = {{34, 18}, {34, 18}, {34, 40}, {0, 40}, {0, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(l2.n, vc.n) annotation(
    Line(points = {{34, -16}, {34, -16}, {34, -40}, {0, -40}, {0, -16}, {0, -16}}, color = {0, 0, 255}));
  connect(vc.n, cal.n) annotation(
    Line(points = {{0, -16}, {0, -16}, {0, -40}, {-34, -40}, {-34, -16}, {-34, -16}}, color = {0, 0, 255}));
  connect(cal.n, calN.n) annotation(
    Line(points = {{-34, -16}, {-34, -16}, {-34, -40}, {-68, -40}, {-68, -16}, {-68, -16}}, color = {0, 0, 255}));
  connect(vc.p, cal.p) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 40}, {-34, 40}, {-34, 18}, {-34, 18}}, color = {0, 0, 255}));
  connect(cal.p, calN.p) annotation(
    Line(points = {{-34, 18}, {-34, 18}, {-34, 40}, {-68, 40}, {-68, 18}, {-68, 18}}, color = {0, 0, 255}));
  connect(ca.c, cal.ca) annotation(
    Line(points = {{-34, -80}, {-12, -80}, {-12, -30}, {-28, -30}, {-28, -16}, {-28, -16}}));
  connect(ca.c, calN.ca) annotation(
    Line(points = {{-34, -80}, {-62, -80}, {-62, -16}, {-62, -16}}));
annotation(
  experiment(StartTime = 0, StopTime = 140, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="act_steady|inact_steady|act_steady_n|act_tau|inact_tau_fast|inact_tau_slow|v|vc\\.v"),
  Documentation(info="
    <html>
      <p>To reproduce Figure S1A and S1B from Inada 2009, plot act_steady and
      inact_steady against v.
      For Figure S1C and S1D, plot inact_tau_fast and inact_tau_slow
      against v.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -80 to 60 mV</li>
        <li>Tolerance: left at default value, since derivatives are not
        relevant</li>
        <li>Interval: enough for a smooth plot</li>
      </ul>
    </html>
  ")
);
end LTypeCalciumSteady;

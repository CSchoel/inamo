within InaMo.Examples.ComponentTests;
model LTypeCalciumSteady "steady state of I_Ca,L, recreates Figures S1A-S1D from Inada 2009"
  extends Modelica.Icons.Example;
  extends InaMo.Concentrations.Interfaces.CaConst;
  extends InaMo.Concentrations.Interfaces.NoACh;
  inner parameter SI.Concentration ca_ex = 0 "extracellular Ca2+ concentration (value not used in this simulation)";
  InaMo.Membrane.LipidBilayer l2(use_init=false) "cell membrane"
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
  InaMo.ExperimentalMethods.VoltageClamp.VoltageClamp vc "voltage clamp"
    annotation(Placement(transformation(extent={{-17, -17}, {17, 17}})));
  InaMo.Currents.Atrioventricular.LTypeCalciumChannel cal "I_Ca,L (AN and NH cells)"
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  InaMo.Currents.Atrioventricular.LTypeCalciumChannelN calN "I_Ca,L (N cell)"
    annotation(Placement(transformation(extent = {{-85, -17}, {-51, 17}})));
  InaMo.Concentrations.Basic.ConstantConcentration ca(c_const=0, vol=0)
    "dummy Ca2+ concentration required to avoid underdetermined equation system"
    annotation(Placement(transformation(extent = {{-51, -80}, {-17, -46}})));
  Real act_steady = cal.act.steady "steady state of activation gate (AN and NH cells)";
  Real act_steady_n = calN.act.steady "steady state of activation gate (N cell)";
  SI.Duration act_tau = cal.act.tau "time constant of activation gate";
  Real inact_steady = cal.inact_slow.steady "steady state of inactivation gates";
  SI.Duration inact_tau_fast = cal.inact_fast.tau "time constant of fast inactivation gate";
  SI.Duration inact_tau_slow = cal.inact_slow.tau "time constant of slow inactivation gate";
  SI.Voltage v(start=-0.08, fixed=true) "input voltage";
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
  connect(ca.substance, cal.ca) annotation(
    Line(points = {{-34, -80}, {-12, -80}, {-12, -30}, {-28, -30}, {-28, -16}, {-28, -16}}));
  connect(ca.substance, calN.ca) annotation(
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

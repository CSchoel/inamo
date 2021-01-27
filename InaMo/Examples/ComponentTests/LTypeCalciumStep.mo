within InaMo.Examples.ComponentTests;
model LTypeCalciumStep "response of I_Ca,L to a step from -40 mV to 10 mV, recreates figure 1H from inada 2009"
  extends Modelica.Icons.Example;
  extends InaMo.Concentrations.Interfaces.CaConst;
  extends InaMo.Concentrations.Interfaces.NoACh;
  inner parameter SI.Concentration ca_ex = 0 "extracellular Ca2+ concentration (value not used in this simulation)";
  InaMo.Currents.Atrioventricular.LTypeCalciumChannel cal(g_max=21e-9)
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  InaMo.Concentrations.Basic.ConstantConcentration ca(vol=v_sub)
    annotation(Placement(transformation(extent = {{-51, -80}, {-17, -46}})));
  InaMo.Membrane.LipidBilayer l2(use_init=false, c=40e-12)
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
  InaMo.ExperimentalMethods.VoltageClamp.VoltageClamp vc(v_stim=if time < 1 then -0.04 else 0.01)
    annotation(Placement(transformation(extent={{-17, -17}, {17, 17}})));
equation
  connect(l2.p, vc.p) annotation(
    Line(points = {{34, 18}, {34, 18}, {34, 40}, {0, 40}, {0, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(vc.p, cal.p) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 40}, {-34, 40}, {-34, 18}, {-34, 18}}, color = {0, 0, 255}));
  connect(l2.n, vc.n) annotation(
    Line(points = {{34, -16}, {34, -16}, {34, -40}, {0, -40}, {0, -16}, {0, -16}}, color = {0, 0, 255}));
  connect(vc.n, cal.n) annotation(
    Line(points = {{0, -16}, {0, -16}, {0, -40}, {-34, -40}, {-34, -16}, {-34, -16}}, color = {0, 0, 255}));
  connect(ca.substance, cal.ca) annotation(
    Line(points = {{-34, -80}, {-14, -80}, {-14, -30}, {-28, -30}, {-28, -16}, {-28, -16}}));
annotation(
  experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-6, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="vc\\.i"),
  Documentation(info="
    <html>
      <p>This example is required separately from LTypeCalciumIV and
      LTypeCalciumIVN, because it needs a much more fine grained step size to
      accurately show the current time course.</p>
      <p>To reproduce Figure S1H in Inada 2009 plot vc.i against time.</p>
      <p>NOTE: Inada et al. state that they used AN cells for plot S1H, but
      actual value of peak current suggests that parameters of NH cells were
      used instead.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow that the steady state is reached both
        before the step and after the step</li>
        <p>Tolerance: default value</p
        <li>Interval: accurately show time course of current</li>
      </ul>
    </html>
  ")
);
end LTypeCalciumStep;

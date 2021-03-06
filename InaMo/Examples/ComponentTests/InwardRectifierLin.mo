within InaMo.Examples.ComponentTests;
model InwardRectifierLin "IV relationshio of I_K1, recreates Figure 8 of Lindblad 1996"
  extends Modelica.Icons.Example;
  InaMo.Currents.Atrioventricular.InwardRectifier kir(g_max=5.088e-9, use_vact=false) "inward rectifier with parameter settings from Lindblad1996"
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  InaMo.Membrane.LipidBilayer l2(c=5e-11, use_init=false) "lipid bilayer with Lindblad1996 settings"
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
  inner parameter SI.Temperature temp = SI.Conversions.from_degC(35) "membrane temperature";
  inner parameter SI.Concentration k_ex = 5 "extracellular potassium concentration";
  InaMo.ExperimentalMethods.VoltageClamp.VoltageClamp vc "voltage clamp"
    annotation(Placement(transformation(extent={{-17, -17}, {17, 17}})));
  discrete SI.Current i_max(start=0, fixed=true, nominal=1e-12) "current obtained at peak";
initial equation
  vc.v_stim = -100e-3;
equation
  // factor required to push value into range where zero crossing can be detected
  when der(vc.i) * 1e12 < 0 then
    i_max = kir.i;
  end when;
  der(vc.v_stim) = 1e-3;
  connect(l2.p, vc.p) annotation(
    Line(points = {{34, 18}, {34, 18}, {34, 40}, {0, 40}, {0, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(vc.p, kir.p) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 40}, {-34, 40}, {-34, 18}, {-34, 18}}, color = {0, 0, 255}));
  connect(l2.n, vc.n) annotation(
    Line(points = {{34, -16}, {34, -16}, {34, -40}, {0, -40}, {0, -16}, {0, -16}}, color = {0, 0, 255}));
  connect(vc.n, kir.n) annotation(
    Line(points = {{0, -16}, {0, -16}, {0, -40}, {-34, -40}, {-34, -16}, {-34, -16}}, color = {0, 0, 255}));
annotation(
  experiment(StartTime = 0, StopTime = 150, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="kir\\.i|i_max|vc\\.v"),
  Documentation(info="
    <html>
      <p>To recreate Figure 8 of Lindblad 1996, plot kir.i / i_max against
      vc.v.</p>
      <p>This example uses a linear input current, because I_K,1 is modeled
      as an immediate current without activation or inactivation kinetics.</p>
      <p>The following parameters are taken from Lindblad 1996 and differ from
      the parameters used by Inada 2009:</p>
      <ul>
        <li>kir.g_max = 5.088 nS (Table 14, Lindblad 1996)</li>
        <li>l2.c = 50pF (Table 14, Lindblad 1996)</li>
        <li>temp = 35 °C (Table 14, Lindblad 1996)</li>
        <li>kir.Use_vact = false</li>
      </ul>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -100 to +50 mV</li>
        <li>Tolerance: default value (previously a value < 1e-9 was required
          for dassl will to pick up the event for i_max.)</li>
        <li>Interval: enough for a smooth plot</li>
      </ul>
    </html>
  ")
);
end InwardRectifierLin;

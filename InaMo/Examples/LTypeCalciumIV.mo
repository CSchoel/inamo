within InaMo.Examples;
model LTypeCalciumIV "IV relationship of I_Ca,L, recreates Figure S1E of Inada 2009"
  extends IVBase(
    vc(v_hold=-0.07, d_hold=5, d_pulse=0.3),
    v_start = -0.06,
    v_inc = 0.005
  );
  extends Modelica.Icons.Example;
  extends InaMo.Interfaces.CaConst;
  extends Modelica.Interfaces.NoACh;
  replaceable InaMo.Components.IonCurrents.LTypeCalciumChannel cal(g_max=21e-9) "calcium channels with parameters from NH model"
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  InaMo.Components.IonConcentrations.ConstantConcentration ca "calcium concentration that is affected by channel"
    annotation(Placement(transformation(extent = {{-51, -80}, {-17, -46}})));
  InaMo.Components.LipidBilayer l2(use_init=false, c=40e-12)
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
equation
  connect(ca.c, cal.ca) annotation(
    Line(points = {{-34, -80}, {-14, -80}, {-14, -30}, {-28, -30}, {-28, -16}, {-28, -16}}));
  connect(l2.p, vc.p) annotation(
    Line(points = {{34, 18}, {34, 18}, {34, 40}, {0, 40}, {0, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(vc.p, cal.p) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 40}, {-34, 40}, {-34, 18}, {-34, 18}}, color = {0, 0, 255}));
  connect(l2.n, vc.n) annotation(
    Line(points = {{34, -16}, {34, -16}, {34, -40}, {0, -40}, {0, -16}, {0, -16}}, color = {0, 0, 255}));
  connect(vc.n, cal.n) annotation(
    Line(points = {{0, -16}, {0, -16}, {0, -40}, {-34, -40}, {-34, -16}, {-34, -16}}, color = {0, 0, 255}));
annotation(
  experiment(StartTime = 0, StopTime = 155, Tolerance = 1e-12, Interval = 1e-2),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="vc\\.(is_peak|vs_peak|v|v_pulse)"),
  Documentation(info="
    <html>
    <p>To reproduce Figure S1E from Inada 2009, plot vc.is_peak against
    vc.vs_peak.
    It is necessary to use vc.vs_peak instead of vc.v_pulse, because vc.is_peak
    captures the peak current from the <i>previous</i> pulse.</p>
    <p>Simulation protocol and parameters are chosen with the following
    rationale:</p>
    <ul>
      <li>StopTime: allow a plot from -60 mV to 80 mv</li>
      <li>Tolerance: detect changes of a single picoampere (For tolerance
      values above 1e-9, dassl will not pick up the event for i_max.)</li>
      <li>Interval: enough to roughly follow time course of current</li>
      <li>d_pulse: according to the description of Figure S1 in Inada 2009</li>
      <li>d_hold: approximately 5 * max(cal.inact.tau_fast)</li>
      <li>v_hold: should be -40 mV according to the description of figure S1,
      but we chose -70 mV as it gives better results for pulses <= -40 mV</li>
      <li>l2.C: according to Table S15 in Inada 2009</li>
    </ul>
    <p>NOTE: We assume parameter values for the NH cell model since the plot for
    S1H shows that Inada et al. clearly used this model although they stated
    that the AN cell model was used for Figure S1H.
    For Figure S1E, however, the parameter value actually makes no difference
    because the plot shows only normalized current.</p>
    </html>
  ")
);
end LTypeCalciumIV;

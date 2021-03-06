within InaMo.Examples.ComponentTests;
model SodiumChannelIV "IV relationship of I_Na, recreates Figure 2 B from Lindblad 1996"
  extends InaMo.Examples.Interfaces.IVBase(
    vc(v_hold=-0.09, d_hold=2, d_pulse=0.05),
    v_start = -0.1
  );
  extends Modelica.Icons.Example;
  InaMo.Currents.Atrioventricular.SodiumChannel na "I_Na"
    annotation(Placement(transformation(extent = {{-51, -17}, {-17, 17}})));
  InaMo.Membrane.LipidBilayer l2(use_init=false, c=50e-12) "cell membrane"
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
  inner parameter SI.Temperature temp = SI.Conversions.from_degC(35) "cell medium temperature";
  // Note: uses Lindblad parameters instead of Inada parameters
  // For Inada2009 we would use na_in = 8, na_ex = 140 and na_p = 1.4e-15 at 310K
  // Note: pl/s -> m³/s by setting p *= 1e-15
  inner parameter SI.Concentration na_in = 8.4 "intracellular sodium concentration";
  inner parameter SI.Concentration na_ex = 75 "extracellular sodium concentration";
  inner parameter PermeabilityFM na_p = 1.4e-15*1.5 "cell membrane permeability for Na+ ions";
  discrete Real cd(unit="A/F") "current density";
initial equation
  cd = vc.is_peak / l2.c;
equation
  when change(vc.is_peak) then
    cd = vc.is_peak / l2.c;
  end when;
  connect(l2.p, vc.p) annotation(
    Line(points = {{34, 18}, {34, 18}, {34, 40}, {0, 40}, {0, 18}, {0, 18}}, color = {0, 0, 255}));
  connect(vc.p, na.p) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 40}, {-34, 40}, {-34, 18}, {-34, 18}}, color = {0, 0, 255}));
  connect(l2.n, vc.n) annotation(
    Line(points = {{34, -16}, {34, -16}, {34, -40}, {0, -40}, {0, -16}, {0, -16}}, color = {0, 0, 255}));
  connect(vc.n, na.n) annotation(
    Line(points = {{0, -16}, {0, -16}, {0, -40}, {-34, -40}, {-34, -16}, {-34, -16}}, color = {0, 0, 255}));
annotation(
  experiment(StartTime = 0, StopTime = 75.8, Tolerance = 1e-6, Interval = 1e-3),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="vc\\.(vs_peak|v|v_pulse)|cd"),
  Documentation(info="
    <html>
      <p>To reproduce Figure 2B from Lindblad 1996, plot cd against
      vc.vs_peak.
      It is necessary to use vc.vs_peak instead of vc.v_pulse, because cd
      captures the current density from the <i>previous</i> pulse.</p>
      <p>Note that results will not be exact as Lindblad 1996 used the full
      model to generate the plots.</p>
      <p>Simulation parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -100 mV to 70 mV</li>
        <p>Tolerance: default value</p
        <li>Interval: roughly show time course of current (Noble 1962 remarks
        that 0.1 ms is the smallest step size needed for RK4.)</li>
      </ul>
      <p>Other parameter settings can be found in Lindblad 1996 on the
      following pages:</p>
      <ul>
        <li>na_in: H1673 (Table 15, initial value)</li>
        <li>na_ex: H1674 (Fig. 2)</li>
        <li>na_p: H1672 (Table 14) + H1673 (top right) + Inada 2009 Supporting material, 27</li>
        <li>temp: H1674 (Fig 2.)</li>
        <li>l2.C: H1672 (Table 14)</li>
        <li>vc.v_hold: H1674 (Fig. 2)</li>
        <li>vc.d_hold: H1674 (Fig. 2) -> Wendt 1992, C1235 (bottom left)</li>
        <li>vc.d_pulse: H1674 (Fig. 2) -> Wendt 1992, C1235 (bottom left)</li>
      </ul>
      <p>NOTE: na_p is the only parameter whose value is not directly taken
      from Lindblad 1996. Lindblad et al. use 1.4 nl while Inada et al. use
      1.4 pl which gives currents in the order of nA instead of μa and
      therefore seems more reasonable (and is more in accordance with the
      plots of Lindblad et al.).</p>
    </html>
  ")
);
end SodiumChannelIV;

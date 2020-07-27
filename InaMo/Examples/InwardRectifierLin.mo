within InaMo.Examples;
model InwardRectifierLin "IV relationshio of I_K1, recreates Figure 8 of Lindblad 1997"
  InwardRectifier kir(g_max=5.088e-9, use_vact=false) "inward rectifier with parameter settings from Lindblad1997";
  LipidBilayer l2(c=5e-11, use_init=false) "lipid bilayer with Lindblad1997 settings";
  inner parameter SI.Temperature temp = SI.Conversions.from_degC(35);
  inner parameter SI.Concentration k_ex = 5;
  VoltageClamp vc;
  discrete SI.Current i_max(start=0, fixed=true);
initial equation
  vc.v_stim = -100e-3;
equation
  when der(vc.i) < 0 then
    i_max = kir.i;
  end when;
  der(vc.v_stim) = 1e-3;
  connect(l2.p, kir.p);
  connect(l2.n, kir.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
annotation(
  experiment(StartTime = 0, StopTime = 150, Tolerance = 1e-12, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="kir\\.i|i_max|vc\\.v"),
  Documentation(info="
    <html>
      <p>To recreate Figure 8 of Lindblad 1997, plot kir.i / i_max against
      vc.v.</p>
      <p>This example uses a linear input current, because I_K,1 is modeled
      as an immediate current without activation or inactivation kinetics.</p>
      <p>The following parameters are taken from Lindblad 1997 and differ from
      the parameters used by Inada 2009:</p>
      <ul>
        <li>kir.g_max = 5.088 nS (Table 14, Lindblad 1997)</li>
        <li>l2.c = 50pF (Table 14, Lindblad 1997)</li>
        <li>temp = 35 °C (Table 14, Lindblad 1997)</li>
        <li>kir.Use_vact = false</li>
      </ul>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -100 to +50 mV</li>
        <li>Tolerance: detect changes of a single picoampere (For tolerance
        values above 1e-9, dassl will not pick up the event for i_max.)</li>
        <li>Interval: enough for a smooth plot</li>
      </ul>
    </html>
  ")
);
end InwardRectifierLin;

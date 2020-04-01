within InaMo.Examples;
model SodiumPotassiumPumpLin "IV relationship of I_p (and I_b), recreates Figure 12 of Demir 1994"
  LipidBilayer l2(C=55e-12, use_init=false);
  VoltageClamp vc;
  MobileIon sodium(c_in=9.67, c_ex=140, z=1, p=0);
  MobileIon potassium(c_in=140.75, c_ex=5.4, z=1, p=0);
  MobileIon calcium_sys(c_in=0.00315, c_ex=1.97);
  MobileIon calcium_dia(c_in=0.00028, c_ex=2.02);
  SodiumPotassiumPump p(sodium=sodium, potassium=potassium, i_max=0.2192e-9);
  BackgroundChannel b(G_max=25.21e-9, V_eq=nernst(calcium_dia, 310)) "background current (AN cell model)";
  parameter SI.Voltage v_start = -0.06;
initial equation
  vc.v_stim = v_start;
equation
  der(vc.v_stim) = 0.001;
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(l2.p, p.p);
  connect(l2.n, p.n);
  connect(l2.p, b.p);
  connect(l2.n, b.n);
annotation(
  experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To recreate Figure 12 of Demir 1994, plot vc.i against vc.v.</p>
      <p>This example uses a linear input current, because I_p is modeled
      as an immediate current without activation or inactivation kinetics.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -60 to +40 mV</li>
        <li>Tolerance: left at default, because derivatives are not relevant
        </li>
        <li>Interval: enough for a smooth plot</li>
        <li>l2.C: according to Table A9 from Demir 1994</li>
        <li>sodium.c_in: according to Table A13 from Demir 1994 (mean)</li>
        <li>sodium.c_ex: according to Table A13 from Demir 1994 (mean)</li>
        <li>potassium.c_in: according to Table A13 from Demir 1994 (mean)</li>
        <li>potassium.c_ex: according to Table A13 from Demir 1994 (mean)</li>
        <li>p.i_max: according to Table A9 from Demir 1994</li>
        <li>p.k_m_K: according to Table A9 from Demir 1994 and
        Table 10 from Zhang 2000 (identical)</li>
        <li>p.k_m_Na: according to Table A9 from Demir 1994 and
        Table 10 from Zhang 2000 (identical)</li>
        <li>b.G_max: according to Table A9 from Demir 1994 (because I_B,Ca
        dominates background currents)</li>
        <li>calcium_sys.c_in: according to Table A13 from Demir 1994</li>
        <li>calcium_sys.c_ex: according to Table A13 from Demir 1994</li>
      </ul>
    </html>
  ")
);
end SodiumPotassiumPumpLin;

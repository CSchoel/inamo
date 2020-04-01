within InaMo.Examples;
model SodiumPotassiumPumpLin "IV relationship of I_p, recreates Figure 12 of Demir 1994"
  LipidBilayer l2(C=55e-12, use_init=false);
  VoltageClamp vc;
  parameter MobileIon sodium(c_in=9.67, c_ex=140, z=1, p=0);
  parameter MobileIon potassium(c_in=140.75, c_ex=5.4, z=1, p=0);
  SodiumPotassiumPump p(sodium=sodium, potassium=potassium, i_max=0.2192e-9);
  parameter SI.Voltage v_start = -0.06;
initial equation
  vc.v_stim = v_start;
equation
  der(vc.v_stim) = 0.001;
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(l2.p, p.p);
  connect(l2.n, p.n);
annotation(
  experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To recreate Figure 12 of Demir 1994, plot vc.i against vc.v.</p>
      <p>This example uses a linear input current, because I_p is modeled
      as an immediate current without activation or inactivation kinetics.</p>
      <p>The results are not fully accurate, because Demir 1994 only report
      the current-voltage relationship of the <i>sum</i> of I_p and the
      three background currents included in their model.</p>
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
      </ul>
      <p>NOTE: Inada et al. give no parameter values for p.k_m_K, p.k_m_Na and
      p.i_max. These parameters have to be taken from Zhang 2000 or Demir 1994.
      Fortunately, both papers agree for the value of p.k_m_K and p.k_m_Na.
      However, for p.i_max, there exists one value in Table A9 from Demir 1994
      and two different values for peripheral and central SA node cells in
      Zhang 2000. We assume that the \"peripheral\" value should be used for
      AN cells and the \"central\" value should be used for the N cell. As
      for the NH cell we currently have no good guess. The CellML
      implementation gives values for p.i_max that do not correspond to either
      Zhang 2000 or Demir 1994. It might be that the authors had the code of
      Inada et al. as reference, but we cannot be sure of that.</p>
    </html>
  ")
);
end SodiumPotassiumPumpLin;
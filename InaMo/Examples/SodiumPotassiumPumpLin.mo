within InaMo.Examples;
model SodiumPotassiumPumpLin "IV relationship of I_p (and I_b), recreates Figure 12 of Demir 1994"
  LipidBilayer l2(use_init=false);
  VoltageClamp vc;
  MobileIon sodium(c_in=8, c_ex=140, z=1, p=0);
  MobileIon potassium(c_in=140, c_ex=5.4, z=1, p=0);
  SodiumPotassiumPump p(sodium=sodium, potassium=potassium);
  BackgroundChannel b(G_max=1.8e-9, V_eq=-52.5e-3) "background current (AN cell model)";
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
      </ul>
    </html>
  ")
);
end SodiumPotassiumPumpLin;

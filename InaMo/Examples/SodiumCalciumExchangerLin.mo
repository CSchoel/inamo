within InaMo.Examples;
model SodiumCalciumExchangerLin "IV relationship of I_NaCa, recreates Figure 19 from Matsuoka 1992"
  SodiumCalciumExchanger naca(sodium=sodium, calcium=calcium);
  LipidBilayer l2(C=40e-12, use_init=false);
  VoltageClamp vc;
  MobileIon sodium(c_in=8, c_ex=140, z=1, p=0);
  ConstantConcentration ca_sub(c_const=0.06397);
  MobileIon calcium(c_in=0, c_ex=2, z=2, p=0);
  // use starting value of [Ca2+]_sub
  parameter SI.Voltage v_start = -140e-3;
initial equation
  vc.v_stim = v_start;
equation
  der(vc.v_stim) = 0.001;
  connect(l2.p, naca.p);
  connect(l2.n, naca.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(ca_sub.c, naca.c_sub);
  connect(l2.T, naca.T);
annotation(
  experiment(StartTime = 0, StopTime = 280, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To recreate Figure 19 of Matsuoka 1992, plot vc.i against vc.v.</p>
      <p>This example uses a linear input current, because I_NaCa is modeled
      as an immediate current without activation or inactivation kinetics.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -140 to +140 mV</li>
        <li>Tolerance: left at default value because derivatives are not
        relevant</li>
        <li>Interval: enough for a smooth plot</li>
      </ul>
    </html>
  ")
);
end SodiumCalciumExchangerLin;

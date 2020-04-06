within InaMo.Examples;
model SodiumCalciumExchangerRamp "I_NaCa during voltage clamp ramp, recreates Figure S6A from Inada 2009"
  SodiumCalciumExchanger naca(sodium=sodium, calcium=calcium);
  LipidBilayer l2(C=40e-12, use_init=false);
  VoltageClamp vc;
  MobileIon sodium(c_in=8, c_ex=140, z=1, p=0);
  MobileIon calcium(c_in=0, c_ex=2, z=2, p=0);
  // use starting value of [Ca2+]_sub
  ConstantConcentration ca_sub(c_const=0.06397e-3);
  parameter Real t_ramp_start = 50e-3;
  parameter Real ramp_duration = 300e-3;
  parameter Real ramp_start = 60e-3;
  parameter Real ramp_rate = -140e-3/300e-3;
  parameter Real v_hold = -40e-3;
  Boolean ramp = time > t_ramp_start and time < t_ramp_start + ramp_duration;
equation
  if ramp then
    vc.v_stim = (time - t_ramp_start) * ramp_rate + ramp_start;
  else
    vc.v_stim = v_hold;
  end if;
  connect(l2.p, naca.p);
  connect(l2.n, naca.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(ca_sub.c, naca.c_sub);
  connect(l2.T, naca.T);
annotation(
  experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-12, Interval = 1e-3),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To recreate Figure S6A of Inada 2009, plot vc.i / l2.C against
      vc.v.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow to see the whole 300 ms ramp in the plot</li>
        <li>Tolerance: left at default value because derivatives are not
        relevant</li>
        <li>Interval: enough for a smooth plot</li>
      </ul>
      <p>NOTE: Inada et al. do not state whether calcium concentration was held
      constant for the experiment and if so, which value was assumed for
      [Ca2+]_sub. We therefore assume a constant concentration at the magnitude
      of the initial value for the AN cell model.</p>
    </html>
  ")
);
end SodiumCalciumExchangerRamp;

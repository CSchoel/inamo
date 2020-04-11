within InaMo.Examples;
model SodiumCalciumExchangerRamp "I_NaCa during voltage clamp ramp, simulation setup from Convery 2000 for Figure S6 of Inada 2009"
  SodiumCalciumExchanger naca(sodium=sodium, calcium=calcium);
  LipidBilayer l2(C=40e-12, use_init=false, T_m=310);
  VoltageClamp vc;
  MobileIon sodium(c_in=8, c_ex=140, z=1, p=0);
  MobileIon calcium(c_in=0, c_ex=2, z=2, p=0);
  ConstantConcentration ca_sub(c_const=0.1e-3);
  parameter Real t_ramp_start = 50e-3;
  parameter Real ramp_duration = 250e-3;
  parameter Real ramp_start = 60e-3;
  parameter Real ramp_end = -80e-3;
  parameter Real v_hold = -40e-3;
  Boolean ramp = time > t_ramp_start and time < t_ramp_start + ramp_duration;
protected
  parameter Real ramp_rate = (ramp_end - ramp_start) / ramp_duration;
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
      <p>This example constitutes the base setup for the voltage ramp
      experiment performed by Convery 2000 whose data is used by Inada 2009
      for Figure S6. This model has to be simulated twice with different
      parameters for the AN and NH cell model and for the N cell model.
      This is done in SodiumCalciumExchangerRampInada.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow to see the whole 300 ms ramp in the plot</li>
        <li>Tolerance: left at default value because derivatives are not
        relevant</li>
        <li>Interval: enough for a smooth plot</li>
        <li>t_ramp_start: according to Figure 4D of Convery 2000</li>
        <li>ramp_duration: according to Convery 2000, p. 379</li>
        <li>ramp_start: according to Convery 2000, p. 397</li>
        <li>ramp_end: according to Convery 2000, p. 397</li>
        <li>v_hold: according to Figure 4D of Convery 2000</li>
      </ul>
    </html>
  ")
);
end SodiumCalciumExchangerRamp;

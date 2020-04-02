within InaMo.Examples;
model SodiumCalciumExchangerRamp "I_NaCa during voltage clamp ramp, recreates Figure S6A from Inada 2009"
  SodiumCalciumExchanger naca(sodium=sodium, calcium=calcium);
  // TODO set parameters of naca
  LipidBilayer l2(C=40e-12, use_init=false);
  VoltageClamp vc;
  MobileIon sodium(c_in=8, c_ex=140, z=1, p=0);
  MobileIon calcium(c_in=0, c_ex=2, z=2, p=0); // use starting value of [Ca2+]_sub
  ConstantConcentration ca_sub(c_const=0.06397);
  parameter Real t_ramp_start = 0.06;
  parameter Real ramp_duration = 0.3;
  parameter Real ramp_start = 50e-3;
  parameter Real ramp_rate = 14/3;
  parameter Real v_hold = -0.04;
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
end SodiumCalciumExchangerRamp;

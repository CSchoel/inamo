within InaMo.Examples;
model SodiumCalciumExchangerLin "IV relationship of I_NaCa, recreates Figure 17 (upper right) from Kurata 2002"
  SodiumCalciumExchanger naca(sodium=sodium, calcium=calcium);
  // TODO set parameters of naca
  LipidBilayer l2(C=40e-12, use_init=false);
  VoltageClamp vc;
  MobileIon sodium(c_in=8, c_ex=140, z=1, p=0);
  MobileIon calcium(c_in=0, c_ex=2, z=2, p=0); // use starting value of [Ca2+]_sub
  ConstantConcentration ca_sub(c_const=0.06397);
  parameter SI.Voltage v_start = -100e-3;
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
end SodiumCalciumExchangerLin;

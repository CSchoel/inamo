within InaMo.Examples;
model InaMoFull
  BackgroundChannel bg;
  HyperpolarizationActivatedChannel hcn;
  InwardRectifier kir;
  LowThresholdChannel st;
  LTypeCalciumChannel cal;
  RapidDelayedRectifierChannel kr;
  SodiumCalciumExchanger naca;
  SodiumChannel na;
  SodiumPotassiumPump nak;
  TransientOutwardChannel to;
  VoltageClamp vc;
  LipidBilayer l2;
  CaHandling ca;
equation
  connect(l2.p, bg.p);
  connect(l2.n, bg.n);
  connect(l2.p, hcn.p);
  connect(l2.n, hcn.n);
  connect(l2.p, kir.p);
  connect(l2.n, kir.n);
  connect(l2.p, st.p);
  connect(l2.n, st.n);
  connect(l2.p, cal.p);
  connect(l2.n, cal.n);
  connect(l2.p, kr.p);
  connect(l2.n, kr.n);
  connect(l2.p, naca.p);
  connect(l2.n, naca.n);
  connect(l2.p, na.p);
  connect(l2.n, na.n);
  connect(l2.p, nak.p);
  connect(l2.n, nak.n);
  connect(l2.p, to.p);
  connect(l2.n, to.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(ca.c_sub.c, cal.c_sub);
  connect(ca.c_sub.c, naca.c_sub);
end InaMoFull;
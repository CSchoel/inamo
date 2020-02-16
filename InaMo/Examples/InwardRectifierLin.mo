within InaMo.Examples;
model InwardRectifierLin
  InwardRectifier kir(G_max=5.088e-9) "inward rectifier with parameter settings from Lindblad1997";
  LipidBilayer l2(T_m=SI.Conversions.from_degC(35), C=5e-11, use_init=false) "lipid bilayer with Lindblad1997 settings";
  VoltageClamp vc;
initial equation
  vc.v_stim = -100;
equation
  der(vc.v_stim) = 1;
  connect(l2.p, kir.p);
  connect(l2.n, kir.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(l2.T, kir.T);
end InwardRectifierLin;

within InaMo.Examples;
model InwardRectifierLin "recreates Figure 8 of Lindblad 1997"
  InwardRectifier kir(G_max=5.088e-9, T=l2.T_m, use_vact=false) "inward rectifier with parameter settings from Lindblad1997";
  LipidBilayer l2(T_m=SI.Conversions.from_degC(35), C=5e-11, use_init=false) "lipid bilayer with Lindblad1997 settings";
  VoltageClamp vc;
  discrete SI.Current i_max(start=0, fixed=true);
initial equation
  vc.v_stim = -100e-3;
equation
  when der(vc.i) < 0 then
    i_max = vc.i;
  end when;
  der(vc.v_stim) = 1e-3;
  connect(l2.p, kir.p);
  connect(l2.n, kir.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  // NOTE: tolerance 1e-6 is not sufficient, only starting at tolerance 1e-9 does the event der(vc.i) < 0 get picked up
annotation(
  experiment(StartTime = 0, StopTime = 200, Tolerance = 1e-12, Interval = 1e-3),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl")
);
end InwardRectifierLin;

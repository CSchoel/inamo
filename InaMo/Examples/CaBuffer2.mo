within InaMo.Examples;
model CaBuffer2 "unit test for Buffer2"
  // uses values for TMC and TMM in AN cell from InaMo
  InaMo.Components.IonConcentrations.Buffer2 tmc(f_start=0.3667, n_tot=0.062*v_cyto, k=227.7e3/v_cyto, kb=0.00751e3);
  InaMo.Components.IonConcentrations.Buffer2 tmm(f_start=0.5594, n_tot=0, k=2.277e3/v_cyto, kb=0.751e3);
  InaMo.Components.IonConcentrations.Compartment ca_cyto(c_start=0.1206e-3, vol=v_cyto);
  InaMo.Components.IonConcentrations.ConstantConcentration mg(c_const=2.5);
  parameter SI.Volume v_cyto = 1.9792021E-15;
equation
  connect(tmc.site, ca_cyto.substance);
  connect(tmm.site, mg.substance);
  connect(tmc.f_other, tmm.f_out);
  connect(tmm.f_other, tmc.f_out);
annotation(
  experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-12, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="ca_cyto\\.c\\.c")
);
end CaBuffer2;

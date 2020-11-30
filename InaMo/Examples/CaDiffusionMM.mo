within InaMo.Examples;
model CaDiffusionMM
  // uses values for cyto_nsr in AN cell
  InaMo.Components.IonConcentrations.SERCAPump cyto_nsr(vol_src=v_cyto, p=0.005e3*v_nsr,k=0.0006);
  InaMo.Components.IonConcentrations.Compartment ca_nsr(c_start=1.068, vol=v_nsr);
  InaMo.Components.IonConcentrations.Compartment ca_cyto(c_start=0.1206e-3, vol=v_cyto);
  parameter SI.Volume v_nsr = 5.10194319E-17;
  parameter SI.Volume v_cyto = 1.9792021E-15;
equation
  connect(ca_cyto.substance, cyto_nsr.src);
  connect(cyto_nsr.dst, ca_nsr.substance);
annotation(
  experiment(StartTime = 0, StopTime = 0.01, Tolerance = 1e-6, Interval = 1e-5),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="ca_(cyto|nsr)\\.con")
);
end CaDiffusionMM;

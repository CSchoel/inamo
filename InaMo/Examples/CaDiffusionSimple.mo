within InaMo.Examples;
model CaDiffusionSimple
  // uses values for sub_cyto in AN cell
  InaMo.Components.IonConcentrations.DiffSimple sub_cyto(tau=0.04e-3);
  InaMo.Components.IonConcentrations.Compartment ca_sub(c_start=0.06397e-3, vol=v_sub);
  InaMo.Components.IonConcentrations.Compartment ca_cyto(c_start=0.1206e-3, vol=v_cyto);
  parameter SI.Volume v_sub = 4.398227E-17;
  parameter SI.Volume v_cyto = 1.9792021E-15;
equation
  connect(ca_sub.substance, sub_cyto.src);
  connect(sub_cyto.dst, ca_cyto.substance);
annotation(
  experiment(StartTime = 0, StopTime = 0.005, Tolerance = 1e-12, Interval = 1e-6),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="ca_(cyto|sub)\\.c\\.c")
);
end CaDiffusionSimple;

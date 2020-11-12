within InaMo.Examples;
model CaBuffer "unit test for buffer model"
  // uses values for TC in AN cell from InaMo
  InaMo.Components.IonConcentrations.Buffer tc(f_start=0.02359, c_tot=0.031, k=88.8e3, kb=0.446e3);
  InaMo.Components.IonConcentrations.Compartment ca_cyto(c_start=0.1206e-3, vol=1.9792021E-15);
equation
  connect(tc.c, ca_cyto.c);
annotation(
  experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-12, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="ca_cyto\\.c\\.c")
);
end CaBuffer;

within InaMo.Examples;
model CaBuffer "unit test for buffer model"
  // uses values for TC in AN cell from InaMo
  InaMo.Concentrations.Basic.Buffer tc(f_start=0.02359, n_tot=0.031*v_cyto, k=88.8e3/v_cyto, kb=0.446e3);
  InaMo.Concentrations.Basic.Compartment ca_cyto(c_start=0.1206e-3, vol=v_cyto);
  parameter SI.Volume v_cyto = 1.9792021E-15;
equation
  connect(tc.site, ca_cyto.substance);
annotation(
  experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-6, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="ca_cyto\\.con")
);
end CaBuffer;

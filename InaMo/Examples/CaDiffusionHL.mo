within InaMo.Examples;
model CaDiffusionHL
  // uses values for jsr_sub in AN cell
  InaMo.Components.IonConcentrations.DiffHL jsr_sub(v_src=v_jsr, v_dst=v_sub, p=5e3, ka=0.0012, n=2);
  InaMo.Components.IonConcentrations.Compartment ca_jsr(c_start=0.4273, vol=v_jsr);
  InaMo.Components.IonConcentrations.Compartment ca_sub(c_start=0.06397e-3, vol=v_sub);
  parameter SI.Volume v_jsr = 5.2778723E-18;
  parameter SI.Volume v_sub = 4.398227E-17;
equation
  connect(ca_sub.c, sub_cyto.src);
  connect(sub_cyto.dst, ca_cyto.c);
annotation(
  experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-12, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="ca_(jsr|sub)\\.c\\.c")
);
end CaDiffusionHL;

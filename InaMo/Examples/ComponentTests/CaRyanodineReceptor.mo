within InaMo.Examples;
model CaRyanodineReceptor
  // uses values for jsr_sub in AN cell
  InaMo.Concentrations.Atrioventricular.RyanodineReceptor jsr_sub(vol_src=v_jsr, vol_dst=v_sub, p=5e3, ka=0.0012, n=2);
  InaMo.Concentrations.Basic.Compartment ca_jsr(c_start=0.4273, vol=v_jsr);
  InaMo.Concentrations.Basic.Compartment ca_sub(c_start=0.06397e-3, vol=v_sub);
  parameter SI.Volume v_jsr = 5.2778723E-18;
  parameter SI.Volume v_sub = 4.398227E-17;
equation
  connect(ca_jsr.substance, jsr_sub.src);
  connect(jsr_sub.dst, ca_sub.substance);
annotation(
  experiment(StartTime = 0, StopTime = 0.002, Tolerance = 1e-8, Interval = 1e-5),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="ca_(jsr|sub)\\.con")
);
end CaRyanodineReceptor;

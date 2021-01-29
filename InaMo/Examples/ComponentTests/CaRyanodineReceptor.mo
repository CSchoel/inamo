within InaMo.Examples.ComponentTests;
model CaRyanodineReceptor "unit test for RyanodineReceptor"
  // uses values for jsr_sub in AN cell
  extends Modelica.Icons.Example;
  InaMo.Concentrations.Atrioventricular.RyanodineReceptor jsr_sub(vol_src=v_jsr, vol_dst=v_sub, p=5e3, ka=0.0012, n=2) "ryanodine receptor";
  InaMo.Concentrations.Basic.Compartment ca_jsr(c_start=0.4273, vol=v_jsr) "Ca2+ in junctional SR";
  InaMo.Concentrations.Basic.Compartment ca_sub(c_start=0.06397e-3, vol=v_sub) "Ca2+ in \"fuzzy\" subspace";
  parameter SI.Volume v_jsr = 5.2778723E-18 "volume of junctional SR";
  parameter SI.Volume v_sub = 4.398227E-17 "volume of \"fuzzy\" subspace";
equation
  connect(ca_jsr.substance, jsr_sub.src);
  connect(jsr_sub.dst, ca_sub.substance);
annotation(
  Documentation(info="<html>
    <p>NOTE: This model does not represent any meaningful experiment, but is
    only used to find errors and unexpected changes in the simulation output
    of the tested component.</p>
  </html>"),
  experiment(StartTime = 0, StopTime = 0.002, Tolerance = 1e-8, Interval = 1e-5),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="ca_(jsr|sub)\\.con")
);
end CaRyanodineReceptor;

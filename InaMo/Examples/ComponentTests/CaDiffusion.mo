within InaMo.Examples.ComponentTests;
model CaDiffusion "unit test for Diffusion"
  // uses values for sub_cyto in AN cell
  extends Modelica.Icons.Example;
  InaMo.Concentrations.Basic.Diffusion sub_cyto(vol_src=v_sub, vol_dst=v_cyto, tau=0.04e-3) "diffusion from subspace into cytosol";
  InaMo.Concentrations.Basic.Compartment ca_sub(c_start=0.06397e-3, vol=v_sub) "Ca2+ in \"fuzzy\" subspace";
  InaMo.Concentrations.Basic.Compartment ca_cyto(c_start=0.1206e-3, vol=v_cyto) "Ca2+ in cytosol";
  parameter SI.Volume v_sub = 4.398227E-17 "volume of \"fuzzy\" subspace (value for AN cell)";
  parameter SI.Volume v_cyto = 1.9792021E-15 "volume of cytosol (value for AN cell)";
equation
  connect(ca_sub.substance, sub_cyto.src);
  connect(sub_cyto.dst, ca_cyto.substance);
annotation(
  experiment(StartTime = 0, StopTime = 0.005, Tolerance = 1e-6, Interval = 1e-6),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="ca_(cyto|sub)\\.con"),
  Documentation(info="<html>
    <p>NOTE: This model does not represent any meaningful experiment, but is
    only used to find errors and unexpected changes in the simulation output
    of the tested component.</p>
    <p>To produce unit test figure, plot <code>ca_cyto.con</code> and
    <code>ca_sub.con</code> against time.</p>
    <p>Simulation protocol and parameters are chosen with the following
    rationale:</p>
    <ul>
      <li>StopTime: just large enough to see some change in variables</li>
      <li>Tolerance: default value</li>
      <li>Interval: same as for InaMo.Examples.ComponentTests.CaHandlingApprox</li>
      <li>model parameters: same as in InaMo.Cells.VariableCa.ANCell</li>
    </ul>
  </html>")
);
end CaDiffusion;

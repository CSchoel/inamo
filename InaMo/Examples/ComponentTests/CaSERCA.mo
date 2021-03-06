within InaMo.Examples.ComponentTests;
model CaSERCA "unit test for SERCAPump"
  // uses values for cyto_nsr in AN cell
  extends Modelica.Icons.Example;
  InaMo.Concentrations.Atrioventricular.SERCAPump cyto_nsr(vol_src=v_cyto, p=0.005e3*v_nsr,k=0.0006) "SERCA pump";
  InaMo.Concentrations.Basic.Compartment ca_nsr(c_start=1.068, vol=v_nsr) "Ca2+ in network SR";
  InaMo.Concentrations.Basic.Compartment ca_cyto(c_start=0.1206e-3, vol=v_cyto) "Ca2+ in cytosol";
  parameter SI.Volume v_nsr = 5.10194319E-17 "volume of network SR (value for AN cell)";
  parameter SI.Volume v_cyto = 1.9792021E-15 "volume of cytosol (value for AN cell)";
equation
  connect(ca_cyto.substance, cyto_nsr.src);
  connect(cyto_nsr.dst, ca_nsr.substance);
annotation(
  Documentation(info="<html>
    <p>NOTE: This model does not represent any meaningful experiment, but is
    only used to find errors and unexpected changes in the simulation output
    of the tested component.</p>
    <p>To produce unit test figure, plot <code>ca_cyto.con</code> and
    <code>ca_nsr.con</code> against time.</p>
    <p>Simulation protocol and parameters are chosen with the following
    rationale:</p>
    <ul>
      <li>StopTime: just large enough to see some change in variables</li>
      <li>Tolerance: default value</li>
      <li>Interval: same as for InaMo.Examples.ComponentTests.CaHandlingApprox</li>
      <li>model parameters: same as in InaMo.Cells.VariableCa.ANCell</li>
    </ul>
  </html>"),
  experiment(StartTime = 0, StopTime = 0.01, Tolerance = 1e-6, Interval = 1e-5),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="ca_(cyto|nsr)\\.con")
);
end CaSERCA;

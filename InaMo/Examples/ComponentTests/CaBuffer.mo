within InaMo.Examples.ComponentTests;
model CaBuffer "unit test for buffer model"
  // uses values for TC in AN cell from InaMo
  extends Modelica.Icons.Example;
  InaMo.Concentrations.Basic.Buffer tc(f_start=0.02359, n_tot=0.031*v_cyto, k=88.8e3/v_cyto, kb=0.446e3) "troponin-Ca";
  InaMo.Concentrations.Basic.Compartment ca_cyto(c_start=0.1206e-3, vol=v_cyto) "Ca2+ in cytosol";
  parameter SI.Volume v_cyto = 1.9792021E-15 "volume of cytosol (value for AN cell)";
equation
  connect(tc.site, ca_cyto.substance);
annotation(
  Documentation(info="<html>
    <p>NOTE: This model does not represent any meaningful experiment, but is
    only used to find errors and unexpected changes in the simulation output
    of the tested component.</p>
    <p>To produce unit test figure, plot <code>ca_cyto.con</code> against
    time.</p>
    <p>Simulation protocol and parameters are chosen with the following
    rationale:</p>
    <ul>
      <li>StopTime: just large enough to see some change in variables</li>
      <li>Tolerance: default value</li>
      <li>Interval: same as for InaMo.Examples.ComponentTests.CaHandlingApprox</li>
      <li>model parameters: same as in InaMo.Cells.VariableCa.ANCell</li>
    </ul>
  </html>"),
  experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-6, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="ca_cyto\\.con")
);
end CaBuffer;

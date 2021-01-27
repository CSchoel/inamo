within InaMo.Examples.ComponentTests;
model CaDiffusion
  // uses values for sub_cyto in AN cell
  extends Modelica.Icons.Example;
  InaMo.Concentrations.Basic.Diffusion sub_cyto(vol_src=v_sub, vol_dst=v_cyto, tau=0.04e-3);
  InaMo.Concentrations.Basic.Compartment ca_sub(c_start=0.06397e-3, vol=v_sub);
  InaMo.Concentrations.Basic.Compartment ca_cyto(c_start=0.1206e-3, vol=v_cyto);
  parameter SI.Volume v_sub = 4.398227E-17;
  parameter SI.Volume v_cyto = 1.9792021E-15;
equation
  connect(ca_sub.substance, sub_cyto.src);
  connect(sub_cyto.dst, ca_cyto.substance);
annotation(
  experiment(StartTime = 0, StopTime = 0.005, Tolerance = 1e-6, Interval = 1e-6),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="ca_(cyto|sub)\\.con"),
  Documentation(info="<html>
    Rationale for parameters
    <ul>
      <li>Tolerance: detect changes in substance amounts on the order of a 1000th of a single molecule.

        <p>This seems to be overkill, but is actually required since the
        smallest value we observe is ca_sub.substance.amount, which is on the
        scale of 1e-21 mol and our regression tests have a default relative
        tolerance of 1e-6.</p>
    </ul>
  </htmL>")
);
end CaDiffusion;

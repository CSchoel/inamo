within InaMo.Components;
model LipidBilayer "lipid bilayer separating external and internal potential (i.e. acting as a capacitor)"
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  import Modelica.SIunits.*;
  TemperatureOutput T = T_m "constant membrane temperature";
  parameter Temperature T_m = from_degC(6.3) "membrane temperature";
  parameter Permittivity C = 0.01 "membrane permittivity (i.e. capacitance per m²)";
  parameter Potential V_init = -0.09 "initial potential (from short initial stimulation)";
initial equation
  V = V_init;
equation
  der(V) = p.I / C;
end LipidBilayer;

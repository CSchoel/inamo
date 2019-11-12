within InaMo.Components;
model LipidBilayer "lipid bilayer separating external and internal potential (i.e. acting as a capacitor)"
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  import InaMo.Components.Connectors.TemperatureOutput;
  TemperatureOutput T = T_m "constant membrane temperature";
  parameter SI.Temperature T_m = SI.Conversions.from_degC(6.3) "membrane temperature";
  parameter SI.Permittivity C = 0.01 "membrane permittivity (i.e. capacitance per m²)";
  parameter SI.ElectricPotential V_init = -0.09 "initial potential (from short initial stimulation)";
initial equation
  v = V_init;
equation
  der(v) = p.i / C;
end LipidBilayer;

within InaMo.Components;
model LipidBilayer "lipid bilayer separating external and internal potential (i.e. acting as a capacitor)"
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  import InaMo.Components.Connectors.TemperatureOutput;
  TemperatureOutput T = T_m "constant membrane temperature";
  parameter SI.Temperature T_m = SI.Conversions.from_degC(37) "membrane temperature";
  parameter SI.Permittivity C = 0.01 "membrane permittivity (i.e. capacitance per m²)";
  parameter SI.ElectricPotential V_init = -0.09 "initial potential (from short initial stimulation)";
  parameter Boolean use_init = true "determines whether initial value for v is used";
initial equation
  if use_init then
    v = V_init;
  end if;
equation
  der(v) = p.i / C;
annotation(
  Documentation(info="<html>
    <p>Model for the lipid bilayer that acts as a capacitor and temperature source.</p>
    <p>By convention, membrane current is defined as positive outward current,
    i.e. the positive pin of this component represents the extracellular
    potential and the negative pin of this component represents the
    intracellular potential.</p>
  </html>")
);
end LipidBilayer;

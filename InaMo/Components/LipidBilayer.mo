within InaMo.Components;
model LipidBilayer "lipid bilayer separating external and internal potential (i.e. acting as a capacitor)"
  extends OnePortVertical;
  extends InaMo.Icons.LipidBilayer;
  import InaMo.Components.Interfaces.TemperatureOutput;
  parameter SI.Capacitance c = 0.01 "membrane capacitance";
  parameter SI.ElectricPotential v_init = -0.09 "initial potential (from short initial stimulation)";
  parameter Boolean use_init = true "determines whether initial value for v is used";
initial equation
  if use_init then
    v = v_init;
  end if;
equation
  der(v) = p.i / c;
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

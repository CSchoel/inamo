within InaMo.Components.IonCurrents;
model GateTSShift "like GateTS but with an additional variable that shifts the steady state curve along the x axis"
  extends GateTS(steady = fsteady(v_gate - shift));
  SI.ElectricPotential shift;
end GateTSShift;

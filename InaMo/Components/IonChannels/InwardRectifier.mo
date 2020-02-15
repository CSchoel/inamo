within InaMo.Components.IonChannels;
model InwardRectifier
  extends IonChannelElectric(G_max=1, V_eq=-81.9);
  TemperatureInput T "membrane temperature";
  parameter MobileIon potassium;
  parameter Real FoRT = 1;
  //Real FoRT = Modelica.Constants.F / T / Modelica.Constants.R;
  InstantRectGate rectifying_gate(
    redeclare function fn = reciprocalRatioFit(x0=0.59),
    c_ex = potassium.c_ex
  );
  InstantGate voltage_gate(
    redeclare function fn = generalizedLogisticFit(x0=V_eq+3.6, sx=-1.393*FoRT)
  );
  InstantGate voltage_gate2(
    redeclare function fn = generalizedLogisticFit(y_min=0.5, x0=-30, se=-5)
  );
equation
  open_ratio = rectifying_gate.n ^ 3 * voltage_gate.n * voltage_gate2.n;
end InwardRectifier;

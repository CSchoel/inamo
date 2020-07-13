within InaMo.Components.IonChannels;
model CalciumPump "I_CaP for atrial cell model (Lindblad 1996)"
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  outer parameter SI.Concentration ca_in;
  parameter SI.Current i_max = 0.16e-9;
equation
  i = i_max * michaelisMenten(ca_in, 0.2e-3);
end CalciumPump;

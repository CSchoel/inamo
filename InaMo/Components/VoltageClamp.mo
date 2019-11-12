within InaMo.Components;
model VoltageClamp "general voltage clamp model"
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  Modelica.Electrical.Analog.Sources.SignalVoltage stim(v=v_stim);
  Modelica.Electrical.Analog.Basic.Ground g;
  SI.Voltage v_stim;
equation
  connect(p, stim.n);
  connect(n, stim.p);
  connect(n, g.p);
end VoltageClamp;

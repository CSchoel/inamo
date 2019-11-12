within InaMo.Components;
model VoltageClamp "general voltage clamp model"
  extends Modelica.Electrical.Analog.Interfaces.TwoPin;
  Modelica.Electrical.Analog.Sources.SignalVoltage stim(v=v_stim);
  Modelica.Electrical.Analog.Basic.Ground g;
  SI.Voltage v_stim;
  SI.Current i = v_stim.i;
equation
  connect(p, stim.p);
  connect(n, stim.n);
  connect(stim.n, g.p);
end VoltageClamp;

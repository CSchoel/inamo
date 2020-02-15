within InaMo.Components;
model VoltageClamp "general voltage clamp model"
  extends Modelica.Electrical.Analog.Interfaces.TwoPin;
  Modelica.Electrical.Analog.Sources.SignalVoltage stim(v=v_stim);
  Modelica.Electrical.Analog.Basic.Ground g;
  SI.Voltage v_stim;
  SI.Current i = -stim.i "measured membrane current";
equation
  connect(p, stim.p);
  connect(n, stim.n);
  connect(stim.n, g.p);
annotation(
  Documentation(info="<html>
  <p>Simple voltage clamp model.</p>
  <p>The positive pin of this component represents the extracellular electrode
  while the negative pin represents the intracellular electrode(s).</p>
  <p>A positive value for v_stim leads to a positive outward voltage.</p>
  </html>")
);
end VoltageClamp;
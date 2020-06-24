within InaMo.Components;
model CurrentClamp
  extends Modelica.Electrical.Analog.Interfaces.TwoPin;
  Modelica.Electrical.Analog.Sources.SignalCurrent stim(i=i_stim);
  Modelica.Electrical.Analog.Basic.Ground g;
  SI.Current i_stim;
equation
  connect(p, stim.p);
  connect(n, stim.n);
  connect(stim.n, g.p);
annotation(
  Documentation(info="<html>
  <p>Simple current clamp model.</p>
  <p>The positive pin of this component represents the extracellular electrode
  while the negative pin represents the intracellular electrode(s).</p>
  <p>A positive value for i_stim leads to a positive outward current.</p>
  </html>")
);
end CurrentClamp;

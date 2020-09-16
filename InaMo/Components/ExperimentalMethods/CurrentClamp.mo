within InaMo.Components.ExperimentalMethods;
model CurrentClamp
  extends InaMo.Interfaces.TwoPinVertical;
  extends InaMo.Icons.CurrentClamp;
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
  </html>"),
  Icon(graphics = {
    Text(
      origin = {57, -68},
      extent = {{-27, 18}, {43, -32}},
      textString = "I"
    )
  })
);
end CurrentClamp;
within InaMo.ExperimentalMethods.CurrentClamp;
model CurrentClamp "current clamp that defines input current to measure voltage response"
  extends InaMo.Currents.Interfaces.TwoPinVertical;
  extends InaMo.Icons.CurrentClamp;
  Modelica.Electrical.Analog.Sources.SignalCurrent stim(i=i_stim) "stimulation model inducing input current into circuit";
  Modelica.Electrical.Analog.Basic.Ground g "ground electrode";
  SI.Current i_stim "input current (needs to be defined externally)";
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
  <p>To measure the voltage in the circuit, the variable v can be used, which
  is introduced through the base class TwoPinVertical.</p>
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

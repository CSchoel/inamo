within InaMo.Examples;
model SodiumChannelExample "try tro recreate figure 2 A and B from lindblad 1997"
  SodiumChannel c(
    ion=sodium,
    T=T
  );
  LipidBilayer l2;
  parameter MobileIon sodium = MobileIon(8.4, 75, 1.4e-9*1.5, 1); //MobileIon(8, 140, 1.4e-9, 1);
  parameter Real T = SI.Conversions.from_degC(35); //310;
  Modelica.Electrical.Analog.Sources.SignalVoltage stim(v=v_stim) "stimulation that holds voltage in channel constant";
  Modelica.Electrical.Analog.Basic.Ground g;
  SI.Voltage v_stim(start=-0.1, fixed=true);
  SI.Voltage c_stim(start=-0.1, fixed=true);
  parameter SI.Voltage v_hold = -0.090;
  parameter SI.Voltage v_inc = 0.005;
  parameter SI.Duration T_sample = 2;
  parameter SI.Duration T_pulse = 0.050;
  Real m3(start=0, fixed=true);
  Real h_total = c.inact_type1.n_steady;
  Real i(start=0, fixed=true);
  parameter Real m_hold = c.activation.falpha(v_hold)
    / (c.activation.falpha(v_hold) + c.activation.fbeta(v_hold));
  parameter Real h_hold = c.inact_type1.falpha(v_hold)
    / (c.inact_type1.falpha(v_hold) + c.inact_type1.fbeta(v_hold));
  // TODO v_stim, m3 and i can be labeled as discrete
equation
  connect(c.p, stim.p);
  connect(stim.n, c.n);
  connect(stim.p, g.p);
  connect(l2.p, c.p);
  connect(l2.n, c.n);
  when sample(0, T_sample) then
    // reset stimulation voltage
    reinit(c_stim, pre(c_stim) + v_inc);
    reinit(v_stim, c_stim);
    // record values from last cycle
    reinit(m3, pre(c.activation.n)^3);
    reinit(i, pre(stim.i));
  elsewhen sample(T_pulse, T_sample) then
    reinit(v_stim, v_hold);
  end when;
  der(v_stim) = 0; // hold v_stim constant
  der(i) = 0;
  der(m3) = 0;
  der(c_stim) = 0;
annotation(
  experiment(StartTime = 0, StopTime = 400, Tolerance = 1e-6, Interval = 1e-2),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To reproduce Figure 2A from Lindblad 1997, plot m3 against
      (v_stim - v_inc) and h_total against v_stim.</p>
      <p>To reproduce Figure 2B from Lindblad 1997, plot i against
      (v_stim - v_inc).</p>
      <p>Note that results will not be exact as Lindblad 1997 used the full
      model to generate the plots. Also we use the parameter settings from
      Inada 2009 for sodium and T and for figure 2B we plot current and
      not current density.</p>
    </html>
  ")
);
end SodiumChannelExample;

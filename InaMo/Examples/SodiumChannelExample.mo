within InaMo.Examples;
model SodiumChannelExample "try tro recreate figure 2 A and B from lindblad 1997"
  SodiumChannel c(
    ion=sodium,
    T=T
  );
  parameter MobileIon sodium = MobileIon(8, 140, 1.4e-9, 1);
  parameter Real T = 310;
  Modelica.Electrical.Analog.Sources.SignalVoltage stim(v=v_stim) "stimulation that holds voltage in channel constant";
  Modelica.Electrical.Analog.Basic.Ground g;
  SI.Voltage v_stim(start=-0.1, fixed=true);
  parameter SI.Voltage v_inc = 0.005;
  parameter SI.Time T_sample = 0.1;
  Real m3(start=0, fixed=true);
  Real h_total = c.inact_type1.n_steady;
  Real i(start=0, fixed=true);
equation
  connect(c.p, stim.p);
  connect(stim.n, c.n);
  connect(stim.p, g.p);
  when sample(0, T_sample) then
    reinit(v_stim, pre(v_stim) + v_inc);
    reinit(m3, pre(c.activation.n)^3);
    reinit(i, pre(stim.i));
  end when;
  der(v_stim) = 0; // hold v_stim constant
  der(i) = 0;
  der(m3) = 0;
annotation(
  experiment(StartTime = 0, StopTime = 3.5, Tolerance = 1e-6, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To reproduce Figure 2A from Lindblad 1997, plot m3 against
      (v_stim - v_inc) and h_total against v_stim.</p>
      <p>To reproduce Figure 2B from Lindblad 1997, plot i against
      (v_stim - v_inc).</p>
      <p>Note that results will not be exact as Lindblad 1997 used the full
      model to generate the plots. Also we use the parameter settings from
      Inada 2009 for sodium and T.</p>
    </html>
  ")
);
end SodiumChannelExample;

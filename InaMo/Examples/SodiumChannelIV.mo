within InaMo.Examples;
model SodiumChannelIV "try tro recreate figure 2 B from lindblad 1997"
  SodiumChannel na(
    ion=sodium,
    T=T
  );
  LipidBilayer l2(use_init=false);
  // Note: uses Lindblad parameters instead of Inada parameters
  // For Inada2009 we would use MobileIon(8, 140, 1.4e-9, 1) at 310K
  parameter MobileIon sodium = MobileIon(8.4, 75, 1.4e-9*1.5, 1);
  parameter Real T = SI.Conversions.from_degC(35);
  VoltageTestPulses vc(v_hold=-0.09, T_hold=2, T_pulse=0.05);
  parameter SI.Voltage v_start = -0.1;
  parameter SI.Voltage v_inc = 0.005;
  discrete Real i(start=0, fixed=true);
  Real min_i(start=0, fixed=true) = min(pre(min_i), vc.i);
initial equation
  vc.v_pulse = v_start;
equation
  connect(l2.p, na.p);
  connect(l2.n, na.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  when vc.pulse_start then
    i = pre(min_i);
    reinit(min_i, 0);
  end when;
  when vc.pulse_end then
    vc.v_pulse = pre(vc.v_pulse) + v_inc;
  end when;
annotation(
  experiment(StartTime = 0, StopTime = 80, Tolerance = 1e-12, Interval = 1e-3),
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
end SodiumChannelIV;

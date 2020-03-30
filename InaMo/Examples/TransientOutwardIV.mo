within InaMo.Examples;
model TransientOutwardIV "IV relationship of I_to, recreates Figures S2E and S2F from Inada 2009"
  extends IVBase(
    vc(v_hold=-0.08, T_hold=20, T_pulse=0.5),
    v_start = -0.06,
    v_inc = 0.005
  );
  TransientOutwardChannel to(G_max=14e-9); // use G_max of NH model
  LipidBilayer l2(use_init=false, C=40e-12);
equation
  connect(l2.p, to.p);
  connect(l2.n, to.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
annotation(
  experiment(StartTime = 0, StopTime = 540, Tolerance = 1e-12, Interval = 1e-2),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
    <p>To reproduce Figure S2E from Inada 2009, plot vc.i against time for
    500 ms after the pulses with amplitude -10, 0, 20 and 40 mV.</p>
    <p>To reproduce Figure S2F from Inada 2009, plot vc.is_peak/max(vc.is_peak)
    against vc.vs_peak.
    It is necessary to use vc.vs_peak instead of vc.v_pulse,
    because vc.is_peak captures the current from the <i>previous</i> pulse.</p>
    <p>Simulation protocol and parameters are chosen with the following
    rationale:</p>
    <ul>
      <li>StopTime: allow a plot from -60 mV to 60 mV</li>
      <li>Tolerance: detect changes of a single picoampere</li>
      <li>Interval: enough to roughly plot time course of current</li>
      <li>T_pulse: according to description of Figure S2 in Inada 2009</li>
      <li>T_hold: approximately 5 * max(inact_slow.tau)</li>
      <li>v_hold: according to description of Figure S2 in Inada 2009</li>
      <li>l2.C: according to Table S15 in Inada 2009 (NH cell model)</li>
      <li>to.G_max: according to Table S15 in Inada 2009 (NH cell model)</li>
    </ul>
    <p>NOTE: Although Inada et al. state that they used the AN cell model for
    Figure S2E and S2F, the absolute values of the current make it seem more
    likely, that the NH cell model was used instead.
    However, with these parameters the model still shows too high absolute
    values for the current.
    We currently have no explanation for this difference other than that
    Inada et al. used different parameters for the plots without documenting
    them./p>
    </html>
  ")
);
end TransientOutwardIV;

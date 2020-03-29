within InaMo.Examples;
model HyperpolarizationActivatedIV "IV relationship of I_f, recreates figures S4C and S4D from Inada 2009"
  extends IVBase(
    vc(v_hold=-0.05, T_hold=20, T_pulse=4),
    v_start = -0.12,
    v_inc = 0.005
  );
  HyperpolarizationActivatedChannel f;
  LipidBilayer l2(use_init=false, C=29e-12);
equation
  connect(l2.p, f.p);
  connect(l2.n, f.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
annotation(
  experiment(StartTime = 0, StopTime = 340, Tolerance = 1e-12, Interval = 1e-1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To reproduce Figure S4C from Inada 2009, plot vc.is_end against
      vc.vs_end.
      It is necessary to use vc.vs_end instead of vc.v_pulse, because cd
      captures the current density from the <i>previous</i> pulse.</p>
      <p>For Figure S4D plot vc.i for 6 seconds following the start of
      the pulses with amplitude -120 to -60 mV.</p>
      <p>The StopTime is chosen to allow a plot from -120 mV to -50 mv.</p>
      <p>Tolerance is chosen to detect changes of a single picoampere.</p>
    </html>
  ")
);
end HyperpolarizationActivatedIV;

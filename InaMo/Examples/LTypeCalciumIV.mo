within InaMo.Examples;
model LTypeCalciumIV "IV relationship of I_Ca,L, recreates Figure S1E of Inada 2009"
  extends IVBase(
    vc(v_hold=-0.07, T_hold=5, T_pulse=0.3),
    v_start = -0.06,
    v_inc = 0.005
  );
  replaceable LTypeCalciumChannel cal(G_max=21e-9) "calcium channels with parameters from NH model";
  ConstantConcentration ca "calcium concentration that is affected by channel";
  LipidBilayer l2(use_init=false, C=40e-12);
equation
  connect(l2.p, cal.p);
  connect(l2.n, cal.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(cal.c_sub, ca.c);
annotation(
  experiment(StartTime = 0, StopTime = 155, Tolerance = 1e-12, Interval = 1e-2),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
    <p>To reproduce Figure S1E from Inada 2009, plot vc.is_peak against
    vc.vs_peak.
    It is necessary to use vc.vs_peak instead of vc.v_pulse, because vc.is_peak
    captures the peak current from the <i>previous</i> pulse.</p>
    <p>The StopTime is chosen to allow a plot from -60 mV to 80 mv.</p>
    <p>Tolerance is chosen to detect changes of a single picoampere.</p>
    <p>T_pulse is chosen according to the description of Figure S1 in
    Inada 2009.
    T_hold is chosen arbitrarily as 5 * max(cal.inact.tau_fast).
    v_hold should be -40 mV according to the description of figure S1, but
    we chose -70 mV as it gives better results for pulses <= -40 mV.</p>
    <p>l2.C is chosen according to Table S15 in Inada 2009, but does not
    affect the magnitude of vc.i during a voltage clamp experiment.</p>
    <p>We assume parameter values for the NH cell model since the plot for
    S1H shows that Inada et al. clearly used this model although they stated
    that the AN cell model was used for Figure S1H.
    However, for Figure S1E the parameter value actually makes no difference
    because the plot shows only normalized current</p>
    </html>
  ")
);
end LTypeCalciumIV;

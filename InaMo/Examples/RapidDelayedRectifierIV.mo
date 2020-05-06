within InaMo.Examples;
model RapidDelayedRectifierIV "IV relationship of I_K,r, recreates Figure S3C-S3E"
  extends IVBase(
    vc(v_hold=-0.04, d_hold=5, d_pulse=0.5),
    v_start = -0.04,
    v_inc = 0.005
  );
  // TODO: why did the refactoring shift the curve of is_tail to the left?
  parameter SI.Concentration na_in = 140;
  parameter SI.Concentration na_ex = 5.4;
  parameter SI.Temperature temp = 310;
  parameter SI.Voltage v_na = nernst(na_in, na_ex, 1, temp);
  RapidDelayedRectifierChannel kr(g_max=1.5e-9, v_eq=v_na) "I_K,r channel with parameters of AN cell model";
  LipidBilayer l2(use_init=false, c=40e-12);
equation
  connect(l2.p, kr.p);
  connect(l2.n, kr.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
annotation(
  experiment(StartTime = 0, StopTime = 115, Tolerance = 1e-12, Interval = 1e-2),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __ChrisS_testing(testedVariableFilter="vc\\.(is_end|vs_end|is_tail|vs_tail|is_peak|vs_peak|i|v|v_pulse)"),
  Documentation(info="
    <html>
    <p>To reproduce Figure S3C from Inada 2009, plot vc.is_end against
    vc.vs_end.
    To reproduce Figure S3D from Inada 2009, plot vc.is_tail against
    vc.vs_tail.
    It is necessary to use vc.vs_end/vc.vs_tail instead of vc.v_pulse,
    because vc.is_end and vc.is_tail capture the current from the
    <i>previous</i> pulse.</p>
    <p>To reproduce Figure S3E from Inada 2009, plot vc.i against time starting
    5 ms before and ending 500ms after the pulses with amplitude -10 mV, 10 mV
    and 30 mV.</p>
    <p>Simulation protocol and parameters are chosen with the following
    rationale:</p>
    <ul>
      <li>StopTime: allow a plot from -40 mV to 60 mV</li>
      <li>Tolerance: detect changes of a single picoampere</li>
      <li>d_pulse: according to description of Figure S3 in Inada 2009</li>
      <li>d_hold: approximately 5 * max(inact.tau)</li>
      <li>v_hold: according to description of Figure S3 in Inada 2009</li>
      <li>l2.C: according to Table S15 in Inada 2009 (AN cell model)</li>
      <li>g_max: according to Table S15 in Inada 2009 (AN cell model)</li>
    </ul>
    <p>NOTE: The resulting plots for Figure S3E still show too high absolute
    values for current and IV-curves in S3C and S3D seem to be shifted towards
    lower voltages.
    This could be explained by a higher value for v_eq (E_k in Inada 2009)
    than the one that can be calculated with nernst.</p>
  ")
);
end RapidDelayedRectifierIV;

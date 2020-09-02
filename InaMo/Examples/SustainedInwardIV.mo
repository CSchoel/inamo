within InaMo.Examples;
model SustainedInwardIV "IV relationship of I_st, recreates Figure S5B and S5C of Inada 2009"
  extends IVBase(
    vc(v_hold=-0.08, d_hold=15, d_pulse=0.5),
    v_start = -0.08,
    v_inc = 0.005
  );
  extends Modelica.Icons.Example;
  SustainedInwardChannel st;
  LipidBilayer l2(use_init=false, c=29e-12);
equation
  connect(l2.p, st.p);
  connect(l2.n, st.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
annotation(
  experiment(StartTime = 0, StopTime = 465, Tolerance = 1e-12, Interval = 1e-2),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="vc\\.(is_peak|vs_peak|i|v|v_pulse)"),
  Documentation(info="
    <html>
    <p>To reproduce Figure S5B from Inada 2009, plot vc.i against time
    starting 50 ms before and ending 100 ms after the pulses with amplitude
    -80 to 60 mV (in 10 mV increments).</p>
    <p>To reproduce Figure S5C from Inada 2009, plot vc.is_peak against
    vc.vs_peak.
    It is necessary to use vc.vs_peak instead of vc.v_pulse,
    because vc.is_peak captures the current from the <i>previous</i> pulse.</p>
    <p>Simulation protocol and parameters are chosen with the following
    rationale:</p>
    <ul>
      <li>StopTime: allow a plot from -80 mV to 60 mV</li>
      <li>Tolerance: detect changes of a single picoampere</li>
      <li>d_pulse: according to description of Figure S5 in Inada 2009</li>
      <li>d_hold: approximately 5 * max(inact.tau)</li>
      <li>v_hold: according to description of Figure S5 in Inada 2009</li>
      <li>l2.C: according to Table S15 in Inada 2009 (N cell model)</li>
    </ul>
    <p>NOTE: The current density in Figure S5B from Inada 2009 is higher, but
    our model is in accordance with Kurata 2002.
    The difference therefore probably arises from (undocumented) changes to
    parameter values by Inada et al..</p>
    </html>
  ")
);
end SustainedInwardIV;

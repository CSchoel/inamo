within InaMo.Examples;
model SustainedInwardIVKurata "IV relationship of I_st, reproduces Figure 4 from Kurata 2002 (bottom left + bottom right)"
  // FIXME redeclare breaks icon inheritance
  extends SustainedInwardIV(
    st(
      act(
        redeclare function fsteady = generalizedLogisticFit(x0=-57e-3, sx=1000/5)
      ),
      g_max=0.48e-9
    ),
    l2(
      c=32e-12
    )
  );
annotation(
  experiment(StartTime = 0, StopTime = 465, Tolerance = 1e-12, Interval = 1e-2),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="vc\\.(i|is_peak|vs_peak|v|v_pulse)"),
  Documentation(info="
    <html>
    <p>This example is identical to SustainedInwardIV with the exception that
    the equation for the steady state of the activation and the parameter
    values for g_max and C are taken from Kurata 2002.</p>
    <p>To reproduce Figure 4 bottom left from Kurata 2002, plot vc.i against
    time starting 50 ms before and ending 100 ms after the pulses with amplitude
    -70 to 50 mV (in 10 mV increments).</p>
    <p>To reproduce Figure 4 bottom right from Kurata 2002, plot vc.is_peak / C
    against vc.vs_peak.
    It is necessary to use vc.vs_peak instead of vc.v_pulse, because vc.is_peak
    captures the current from the <i>previous</i> pulse.</p>
    <p>Simulation protocol and parameters are chosen with the same rationale
    as in SustainedInwardIV.</p>
    </html>
  ")
);
end SustainedInwardIVKurata;

within InaMo.Examples.ComponentTests;
model LTypeCalciumIVN "IV relationship of I_Ca,L, recreates Figure S1E of Inada 2009"
  // FIXME redeclare breaks icon inheritance
  extends LTypeCalciumIV(redeclare LTypeCalciumChannelN cal(g_max=21e-9));
annotation(
  experiment(StartTime = 0, StopTime = 164, Tolerance = 1e-6, Interval = 1e-2),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="vc\\.(is_peak|vs_peak|v|v_pulse)"),
  Documentation(info="
    <html>
    <p>This example uses the same settings as LTypeCalciumIV, but uses the
    equations for the N cell model instead of the AN/NH cell models.</p>
    <p>To reproduce Figure S1E from Inada 2009, plot vc.is_peak against
    vc.vs_peak.
    It is necessary to use vc.vs_peak instead of vc.v_pulse, because vc.is_peak
    captures the peak current from the <i>previous</i> pulse.</p>
    <p>All parameters are set to the same values as in LTypeCalciumIV with the
    same rationale.</p>
    </html>
  ")
);
end LTypeCalciumIVN;

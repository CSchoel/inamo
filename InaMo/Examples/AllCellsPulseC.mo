within InaMo.Examples;
model AllCellsPulseC
  FullCellCurrentPulses an(redeclare ANCellConst cell);
  FullCellCurrentPulses n(redeclare NCellConst cell);
  FullCellCurrentPulses nh(redeclare NHCellConst cell);
annotation(
  experiment(StartTime = 0, StopTime = 2.5, Tolerance = 1e-12, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __ChrisS_testing(testedVariableFilter="(an|n|nh)\\.cell\\.v")
);
end AllCellsPulseC;

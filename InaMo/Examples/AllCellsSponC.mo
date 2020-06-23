within InaMo.Examples;
model AllCellsSponC
  FullCellSpon an(redeclare ANCellConst cell);
  FullCellSpon n(redeclare NCellConst cell);
  FullCellSpon nh(redeclare NHCellConst cell);
annotation(
  experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-12, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __ChrisS_testing(testedVariableFilter="(an|n|nh)\\.cell\\.v")
);
end AllCellsSponC;

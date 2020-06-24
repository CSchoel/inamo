within InaMo.Examples;
model AllCells
  FullCellCurrentPulses an(redeclare ANCell cell);
  FullCellSpon n(redeclare NCell cell);
  FullCellCurrentPulses nh(redeclare NHCell cell);
annotation(
  experiment(StartTime = 0, StopTime = 2.5, Tolerance = 1e-12, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __ChrisS_testing(testedVariableFilter="(an|n|nh)\\.cell\\.(v|ca\\.(sub|cyto)\\.c\\.c)")
);
end AllCells;

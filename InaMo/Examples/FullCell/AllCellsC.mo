within InaMo.Examples.FullCell;
model AllCellsC
  extends Modelica.Icons.Example;
  FullCellCurrentPulses an(redeclare ANCellConst cell);
  FullCellSpon n(redeclare NCellConst cell);
  FullCellCurrentPulses nh(redeclare NHCellConst cell);
annotation(
  experiment(StartTime = 0, StopTime = 2.5, Tolerance = 1e-6, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="(an|n|nh)\\.cell\\.v")
);
end AllCellsC;

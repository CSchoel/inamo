within InaMo.Examples.FullCell;
model AllCellsC "simulation of all cell types with constant intracellular Ca2+"
  extends Modelica.Icons.Example;
  FullCellCurrentPulses an(redeclare InaMo.Cells.ConstantCa.ANCellConst cell) "AN cell experiment";
  FullCellSpon n(redeclare InaMo.Cells.ConstantCa.NCellConst cell) "N cell experiment";
  FullCellCurrentPulses nh(redeclare InaMo.Cells.ConstantCa.NHCellConst cell) "NH cell experiment";
annotation(
  experiment(StartTime = 0, StopTime = 2.5, Tolerance = 1e-6, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="(an|n|nh)\\.cell\\.v")
);
end AllCellsC;

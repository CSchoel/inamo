model AllCells
  FullCellCurrentPulses an(redeclare ANCell cell, cc.i_pulse = -1.2e-9);
  FullCellSpon n(redeclare NCell cell);
  FullCellCurrentPulses nh(redeclare NHCell cell, cc.i_pulse = -0.95e-9);
  extends Modelica.Icons.Example;
  annotation(
    experiment(StartTime = 0, StopTime = 2.5, Tolerance = 1e-12, Interval = 1e-4),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
    __MoST_experiment(variableFilter = "(an|n|nh)\\.cell\\.(v|ca\\.(sub|cyto)\\.c\\.c)"));
end AllCells;
within InaMo.Examples;
model AtrialCellSmokeTest
  extends FullCellCurrentPulses(
    redeclare InaMo.Components.Cells.ACell cell
  );
annotation(
  experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-6, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="cell\\.(v|ca\\.(sub|cyto)\\.con)"),
  Documentation(info="
    <html>
      <p>This model is only a smoke test: It does not reproduce any reference
      plot or even resemble a sensible experiment, but is only used to make
      sure that the atrial cell model compiles and that we do not break
      it any more than it already is. ;P</p>
      <p>When the atrial cell model is finished, this can be turned into
      a real unit test with expected output.</p>
    </html>
  ")
);
end AtrialCellSmokeTest;

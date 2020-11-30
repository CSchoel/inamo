
within InaMo.Examples;
model AtrialCellSmokeTest
  extends FullCellCurrentPulses(
    redeclare InaMo.Components.Cels.ACell cell
  );
annotation(
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

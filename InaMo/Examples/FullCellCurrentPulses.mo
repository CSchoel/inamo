within InaMo.Examples;
model FullCellCurrentPulses
  extends Modelica.Icons.Example;
  replaceable ANCell cell;
  CCTestPulses cc(i_hold=0, i_pulse=-2e-9, d_hold=1, d_pulse=0.001);
equation
  connect(cell.p, cc.p);
  connect(cell.n, cc.n);
end FullCellCurrentPulses;

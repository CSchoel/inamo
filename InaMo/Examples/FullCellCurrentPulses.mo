within InaMo.Examples;
model FullCellCurrentPulses
  extends Modelica.Icons.Example;
  replaceable ANCell cell
    annotation(Placement(transformation(extent = {{13, 29}, {47, 63}})));
  InaMo.Components.CCTestPulses cc(i_hold=0, i_pulse=-2e-9, d_hold=1, d_pulse=0.001)
    annotation(Placement(transformation(extent = {{-43, -57}, {-9, -23}})));
equation
  connect(cell.p, cc.p); // TODO
  connect(cell.n, cc.n);
end FullCellCurrentPulses;

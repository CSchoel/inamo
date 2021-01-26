within InaMo.Examples;
model FullCellCurrentPulses
  extends Modelica.Icons.Example;
  replaceable InaMo.Cells.VariableCa.ANCell cell
    annotation(Placement(transformation(extent = {{13, 29}, {47, 63}})));
  // NOTE d_hold = 0.3 was experimentally determined to be closest to Inada 2009, S7
  // other values tried: 0.1, 0.2, 0.25, 0.4, 0.5, 1
  InaMo.ExperimentalMethods.CurrentClamp.CCTestPulses cc(i_hold=0, i_pulse=-2e-9, d_hold=0.3, d_pulse=0.001)
    annotation(Placement(transformation(extent = {{-43, -57}, {-9, -23}})));
equation
  connect(cc.p, cell.p) annotation(
    Line(points = {{-26, -22}, {-26, -22}, {-26, 78}, {22, 78}, {22, 64}, {22, 64}}, color = {0, 0, 255}));
  connect(cc.n, cell.n) annotation(
    Line(points = {{-26, -56}, {-26, -56}, {-26, -66}, {8, -66}, {8, 46}, {22, 46}, {22, 46}}, color = {0, 0, 255}));
end FullCellCurrentPulses;

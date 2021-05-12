model FullCellSpon "base model for full cell simulation without stimulation"
  extends Modelica.Icons.Example;
  replaceable InaMo.Cells.VariableCa.NCell cell "cell that should be tested" annotation(
    Placement(transformation(extent = {{13, 29}, {47, 63}})));
  Modelica.Electrical.Analog.Basic.Ground g "electrical ground to provide reference potential" annotation(
    Placement(transformation(extent = {{-43, -57}, {-9, -23}})));
equation
  connect(cell.n, g.p) annotation(
    Line(points = {{-26, -22}, {-26, -22}, {-26, 46}, {22, 46}, {22, 46}}, color = {0, 0, 255}));
end FullCellSpon;
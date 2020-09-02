within InaMo.Examples;
model FullCellSpon
  extends Modelica.Icons.Example;
  replaceable NCell cell;
  Modelica.Electrical.Analog.Basic.Ground g;
equation
  connect(cell.n, g.p);
end FullCellSpon;

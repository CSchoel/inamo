within InaMo.Examples;
model FullCellSpon
  replaceable ANCell cell;
  Modelica.Electrical.Analog.Basic.Ground g;
equation
  connect(cell.n, g.p);
end FullCellSpon;

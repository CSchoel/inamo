within InaMo.Examples;
model FullCellSpon
  // FIXME simulation crashes with 1/nan error when model with CaHandling is used
  // FIXME neither AN nor N cell show spontaneous action potential generation
  replaceable ANCellConst cell;
  Modelica.Electrical.Analog.Basic.Ground g;
equation
  connect(cell.n, g.p);
end FullCellSpon;

within InaMo.Examples;
partial model FullCellVC
  replaceable ANCell cell;
  VoltageClamp vc;
equation
  connect(cell.p, vc.p);
  connect(cell.n, vc.n);
end FullCellVC;

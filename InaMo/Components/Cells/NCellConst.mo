within InaMo.Components.Cells;
model NCellConst
  extends NCellBase;
  ConstantConcentration ca_sub;
equation
  connect(ca_sub.c, cal.ca_sub);
  connect(ca_sub.c, naca.ca_sub);
end NCellConst;

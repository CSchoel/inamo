within InaMo.Components.Cells;
model NCellConst
  extends NCellBase(cal(ca_const=true), naca(ca_const=true));
  ConstantConcentration ca_sub(c_const=10e-4); // Inada 2009 supplement, p. 3
equation
  connect(ca_sub.c, cal.ca_sub);
  connect(ca_sub.c, naca.ca_sub);
end NCellConst;

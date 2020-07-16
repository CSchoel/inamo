within InaMo.Components.Cells;
model ANCellConst
  extends ANCellBase(cal(ca_const=true), naca(ca_const=true));
  ConstantConcentration ca_sub(c_const=10e-4); // Inada 2009 supplement, p. 3
equation
  connect(ca_sub.c, cal.ca);
  connect(ca_sub.c, naca.ca);
end ANCellConst;

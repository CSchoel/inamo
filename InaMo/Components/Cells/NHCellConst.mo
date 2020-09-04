within InaMo.Components.Cells;
model NHCellConst
  extends NHCellBase(cal(ca_const=true), naca(ca_const=true));
  InaMo.Components.IonConcentrations.ConstantConcentration ca_sub(c_const=10e-4) // Inada 2009 supplement, p. 3
    annotation(Placement(transformation(origin = {16, 0}, extent = {{-17, -17}, {17, 17}})));
equation
  connect(ca_sub.c, cal.ca);
  connect(ca_sub.c, naca.ca);
end NHCellConst;

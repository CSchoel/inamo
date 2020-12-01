within InaMo.Components.Cells;
model NHCellConst
  extends NHCellBase;
  extends InaMo.Icons.CellConst(cell_type="NH");
  InaMo.Components.IonConcentrations.ConstantConcentration ca_sub(c_const=10e-4, vol=v_sub) // Inada 2009 supplement, p. 3
    annotation(Placement(transformation(origin = {16, 0}, extent = {{-17, -17}, {17, 17}})));
equation
  connect(cal.ca, ca_sub.substance) annotation(
    Line(points = {{-34, -36}, {-36, -36}, {-36, -6}, {-10, -6}, {-10, -16}, {16, -16}, {16, -16}}));
  connect(ca_sub.substance, naca.ca) annotation(
    Line(points = {{16, -16}, {-10, -16}, {-10, 38}, {-12, 38}, {-12, 36}}));
end NHCellConst;

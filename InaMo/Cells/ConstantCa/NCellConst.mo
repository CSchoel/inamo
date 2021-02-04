within InaMo.Cells.ConstantCa;
model NCellConst "nodal cell model with constant intracellular Ca2+ concentration"
  extends InaMo.Cells.Interfaces.NCellBase;
  extends InaMo.Icons.CellConst(cell_type="N");
  InaMo.Concentrations.Basic.ConstantConcentration ca_sub(c_const=1e-4, vol=v_sub)
    "Ca2+ in subspace available to Ca2+-sensitive currents"
    annotation(Placement(transformation(origin = {16, 0}, extent = {{-17, -17}, {17, 17}})));
equation
  connect(cal.ca, ca_sub.substance) annotation(
    Line(points = {{-34, -36}, {-36, -36}, {-36, -6}, {-10, -6}, {-10, -16}, {16, -16}, {16, -16}}));
  connect(ca_sub.substance, naca.ca) annotation(
    Line(points = {{16, -16}, {-10, -16}, {-10, 38}, {-12, 38}, {-12, 36}}));
annotation(Documentation(info="<html>
  <p>NOTE: Inada et al. state that they also performed experiments with constant
  intracellular Ca2+ at 0.1 μM (see supplement, page 3), but they do not give
  any reference plots for this setup.</p>
</html>"));
end NCellConst;

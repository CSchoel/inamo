within InaMo.Cells.VariableCa;
model NHCell "full nodal-his cell model by Inada et al. (2009)"
  extends NHCellBase;
  extends InaMo.Icons.CellVar(cell_type="NH");
  // starting values for CaHandling are from Inada 2009
  InaMo.Components.IonConcentrations.CaHandling ca(
    cyto.c_start = 0.1386e-3,
    sub.c_start = 0.07314e-3,
    jsr.c_start = 0.4438, // [Ca2+]_rel
    nsr.c_start = 1.187,
    tc.f_start = 0.02703,
    tmc.f_start = 0.4020,
    tmm.f_start = 0.5282,
    cm_cyto.f_start = 0.05530,
    cm_sub.f_start = 0.02992,
    cq.f_start = 0.3463,
    cm_sl.f_start = 4.843e-5,
    jsr_sub.p = 1805.6 // NOTE: value from C++ code, not given in paper
  ) "intracellular Ca2+ handling by SR and buffers"
    annotation(Placement(transformation(origin = {16, 0}, extent = {{-17, -17}, {17, 17}})));
equation
  connect(ca.ca_sub, naca.ca) annotation(
    Line(points = {{0, 0}, {-10, 0}, {-10, 36}, {-12, 36}, {-12, 36}}));
  connect(cal.ca, ca.ca_sub) annotation(
    Line(points = {{-34, -36}, {-34, -36}, {-34, 0}, {0, 0}, {0, 0}}));
end NHCell;

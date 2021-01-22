within InaMo.Components.Cells;
model ANCell "full atrio-nodal cell model by Inada et al. (2009)"
  extends ANCellBase;
  extends InaMo.Icons.CellVar(cell_type="AN");
  // starting values for CaHandling are from Inada 2009
  InaMo.Components.IonConcentrations.CaHandling ca(
    cyto.c_start = 0.1206e-3,
    sub.c_start = 0.06397e-3,
    jsr.c_start = 0.4273, // [Ca2+]_rel
    nsr.c_start = 1.068,
    tc.f_start = 0.02359,
    tmc.f_start = 0.3667,
    tmm.f_start = 0.5594,
    cm_cyto.f_start = 0.04845,
    cm_sub.f_start = 0.02626,
    cq.f_start = 0.3379,
    cm_sl.f_start = 3.936e-5,
    jsr_sub.p = 1805.6 // NOTE: value from C++ code, not given in paper
  ) "intracellular Ca2+ handling by SR and buffers"
    annotation(Placement(transformation(origin = {16, 0}, extent = {{-17, -17}, {17, 17}})));
equation
  connect(ca.ca_sub, naca.ca) annotation(
    Line(points = {{0, 0}, {-10, 0}, {-10, 36}, {-12, 36}, {-12, 36}}));
  connect(cal.ca, ca.ca_sub) annotation(
    Line(points = {{-34, -36}, {-34, -36}, {-34, 0}, {0, 0}, {0, 0}}));
end ANCell;

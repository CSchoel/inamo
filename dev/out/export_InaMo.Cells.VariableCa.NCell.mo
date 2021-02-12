model NCell "full nodal cell model by Inada et al. (2009)"
  extends InaMo.Cells.Interfaces.NCellBase;
  extends InaMo.Icons.CellVar(cell_type = "N");
  // starting values for CaHandling are from Inada 2009
  InaMo.Concentrations.Atrioventricular.CaHandling ca(cyto.c_start = 0.3623e-3, sub.c_start = 0.2294e-3, jsr.c_start = 0.08227, nsr.c_start = 1.146, tc.f_start = 0.6838, tm.f_a_start = 0.6192, tm.f_b_start = 0.3363, cm_cyto.f_start = 0.1336, cm_sub.f_start = 0.08894, cq.f_start = 0.08736, cm_sl.f_start = 4.764e-5, jsr_sub.p = 1500) "intracellular Ca2+ handling by SR and buffers" annotation(
    Placement(transformation(origin = {16, 0}, extent = {{-17, -17}, {17, 17}})));
  // [Ca2+]_rel
  // NOTE: value from C++ code, not given in paper
equation
  connect(ca.ca_sub, naca.ca) annotation(
    Line(points = {{0, 0}, {-10, 0}, {-10, 36}, {-12, 36}, {-12, 36}}));
  connect(cal.ca, ca.ca_sub) annotation(
    Line(points = {{-34, -36}, {-34, -36}, {-34, 0}, {0, 0}, {0, 0}}));
end NCell;
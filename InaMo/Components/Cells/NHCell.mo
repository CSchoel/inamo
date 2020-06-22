within InaMo.Components.Cells;
model NHCell
  extends NHCellBase;
  // starting values for CaHandling are from Inada 2009
  CaHandling ca(
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
  );
equation
  connect(ca.sub.c, cal.ca_sub);
  connect(ca.sub.c, naca.ca_sub);
end NHCell;

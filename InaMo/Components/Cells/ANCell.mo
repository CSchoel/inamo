within InaMo.Components.Cells;
model ANCell
  extends ANCellBase;
  // starting values for CaHandling are from Inada 2009
  CaHandling ca(
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
  );
equation
  connect(ca.sub.c, cal.ca);
  connect(ca.sub.c, naca.ca);
end ANCell;

within InaMo.Components.Cells;
model NCell
  extends NCellBase;
  // starting values for CaHandling are from Inada 2009
  CaHandling ca(
    cyto.c_start = 0.3623e-3,
    sub.c_start = 0.2294e-3,
    jsr.c_start = 0.08227, // [Ca2+]_rel
    nsr.c_start = 1.146,
    tc.f_start = 0.6838,
    tmc.f_start = 0.6192,
    tmm.f_start = 0.3363,
    cm_cyto.f_start = 0.1336,
    cm_sub.f_start = 0.08894,
    cq.f_start = 0.08736,
    cm_sl.f_start = 4.764e-5,
    jsr_sub.p = 1500 // NOTE: value from C++ code, not given in paper
  );
equation
  connect(ca.ca_sub, cal.ca);
  connect(ca.ca_sub, naca.ca);
end NCell;

within InaMo.Examples;
model CaHandlingApprox "unit test for CaHandling with approximated currents"
  import InaMo.Components.Connectors.IonConcentration;
  import InaMo.Components.IonConcentrations.CaHandling;
  import InaMo.Components.Functions.Fitting.negSquaredExpFit;
  import InaMo.Components.IonConcentrations.CaFlux;
  model DummyCaL
    extends CaFlux(n_ca=1, vol_ca=v_sub);
    outer parameter SI.Volume v_sub;
    SI.Current i = negSquaredExpFit(time, y_min=0, y_max=-3e-10, x0=0.2, sx=200)
                 + negSquaredExpFit(time, y_min=0, y_max=-1e-10, x0=0.23, sx=30)
                 + negSquaredExpFit(time, y_min=0, y_max=-1e-10, x0=-0.1, sx=6);
    inner SI.Current i_ion = i;
  end DummyCaL;
  model DummyNaCa
    extends CaFlux(n_ca=1, vol_ca=v_sub);
    outer parameter SI.Volume v_sub;
    SI.Current i = negSquaredExpFit(time, y_min=-0.5e-11, y_max=-4e-11, x0=0.2, sx=200)
                 + negSquaredExpFit(time, y_min=-0.5e-11, y_max=0.3e-11, x0=0.23, sx=50)
                 + negSquaredExpFit(time, y_min=0, y_max=-0.5e-10, x0=-0.1, sx=6);
    inner SI.Current i_ion = i;
  end DummyNaCa;
  DummyCaL cal;
  DummyNaCa naca;
  CaHandling ca(
    cyto.c_start = 0.3623e-3,
    sub.c_start = 0.2294e-3,
    jsr.c_start = 0.08227,
    nsr.c_start = 1.146,
    tc.f_start = 0.6838,
    tmc.f_start = 0.6192,
    tmm.f_start = 0.3363,
    cm_cyto.f_start = 0.1336,
    cm_sub.f_start = 0.08894,
    cq.f_start = 0.08736,
    cm_sl.f_start = 4.764e-5,
    jsr_sub.p = 1500
  ) "same parameter settings as in NCell";
  inner parameter SI.Volume v_sub = 3.1887126E-17 "value from C++ for N-cell";
  inner parameter SI.Volume v_cyto = 1.43492067E-15 "value from C++ for N-cell";
  inner parameter SI.Volume v_nsr = 3.698906616E-17 "value from C++ for N-cell";
  inner parameter SI.Volume v_jsr = 3.82645512E-18 "value from C++ for N-cell";
equation
  connect(ca.sub.c, cal.ca);
  connect(ca.sub.c, naca.ca);
annotation(
  experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-12, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __ChrisS_testing(testedVariableFilter="(cal|naca)\\.i|ca\\.(sub|cyto|jsr|nsr)\\.c\\.c")
);
end CaHandlingApprox;

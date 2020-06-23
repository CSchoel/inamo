within InaMo.Examples;
model CaHandlingApprox "unit test for CaHandling with approximated currents"
  import InaMo.Components.Connectors.IonConcentration;
  import InaMo.Components.IonConcentrations.CaHandling;
  import InaMo.Components.Functions.Fitting.negSquaredExpFit;
  model DummyCaL
    IonConcentration ca_sub;
    outer parameter SI.Volume v_sub;
    SI.Current i = negSquaredExpFit(time, y_min=0, y_max=-3e-10, x0=0.2, sx=10);
  equation
    ca_sub.rate = i / (2 * Modelica.Constants.F * v_sub);
  end DummyCaL;
  model DummyNaCa
    IonConcentration ca_sub;
    outer parameter SI.Volume v_sub;
    SI.Current i = negSquaredExpFit(time, y_min=-0.5e-11, y_max=-4e-11, x0=0.2, sx=10)
                 + negSquaredExpFit(time, y_min=-0.5e-11, y_max=0, x0=0.25, sx=5);
  equation
    ca_sub.rate = -2 * i / (2 * Modelica.Constants.F * v_sub);
  end DummyNaCa;
  DummyCaL cal;
  DummyNaCa naca;
  CaHandling ca;
  inner parameter SI.Volume v_sub = 1.43492067E-15 "value from C++ for N-cell";
  inner parameter SI.Volume v_cyto = 3.1887126E-17 "value from C++ for N-cell";
  inner parameter SI.Volume v_nsr = 3.698906616E-17 "value from C++ for N-cell";
  inner parameter SI.Volume v_jsr = 3.82645512E-18 "value from C++ for N-cell";
equation
  connect(ca.sub.c, cal.ca_sub);
  connect(ca.sub.c, naca.ca_sub);
annotation(
  experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-12, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __ChrisS_testing(testedVariableFilter="(cal|naca)\\.i|ca\\.(sub|cyto|jsr|nsr)\\.c\\.c")
);
end CaHandlingApprox;

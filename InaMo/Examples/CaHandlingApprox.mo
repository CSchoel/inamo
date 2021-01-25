within InaMo.Examples;
model CaHandlingApprox "unit test for CaHandling with approximated currents"
  extends Modelica.Icons.Example;
  import InaMo.Components.IonConcentrations.CaHandling;
  import InaMo.Components.Functions.Fitting.gaussianAmp;
  import InaMo.Components.IonConcentrations.TransmembraneCaFlow;
  model DummyCaL
    extends TransmembraneCaFlow(n_ca=1);
    SI.Current i = gaussianAmp(time, y_min=0, y_max=-3e-10, x0=0.2, sigma=3.54e-3)
                 + gaussianAmp(time, y_min=0, y_max=-1e-10, x0=0.23, sigma=23.6e-3)
                 + gaussianAmp(time, y_min=0, y_max=-1e-10, x0=-0.1, sigma=118e-3);
    inner SI.Current i_ion = i;
  end DummyCaL;
  model DummyNaCa
    extends TransmembraneCaFlow(n_ca=-2);
    SI.Current i = gaussianAmp(time, y_min=-0.5e-11, y_max=-4e-11, x0=0.2, sigma=3.54e-3)
                 + gaussianAmp(time, y_min=-0.5e-11, y_max=0.3e-11, x0=0.23, sigma=14.1e-3)
                 + gaussianAmp(time, y_min=0, y_max=-0.5e-10, x0=-0.1, sigma=118e-3);
    inner SI.Current i_ion = i;
  end DummyNaCa;
  DummyCaL cal
     annotation(Placement(transformation(extent = {{-17, 31}, {17, 65}})));
  DummyNaCa naca
     annotation(Placement(transformation(extent = {{-65, 31}, {-31, 65}})));
  InaMo.Components.IonConcentrations.CaHandling ca(
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
  ) "same parameter settings as in NCell"
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
  inner parameter SI.Volume v_sub = 3.1887126E-17 "value from C++ for N-cell";
  inner parameter SI.Volume v_cyto = 1.43492067E-15 "value from C++ for N-cell";
  inner parameter SI.Volume v_nsr = 3.698906616E-17 "value from C++ for N-cell";
  inner parameter SI.Volume v_jsr = 3.82645512E-18 "value from C++ for N-cell";
  inner parameter SI.Concentration ca_ex = 0 "extracellular Ca2+ concentration (value not used in this simulation)";
equation
  connect(cal.ca, ca.ca_sub) annotation(
    Line(points = {{6, 32}, {6, 32}, {6, 0}, {18, 0}, {18, 0}}));
  connect(naca.ca, ca.ca_sub) annotation(
    Line(points = {{-42, 32}, {-42, 32}, {-42, 0}, {18, 0}, {18, 0}}));
annotation(
  experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-7, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="(cal|naca)\\.i|ca\\.(sub|cyto|jsr|nsr)\\.con")
);
end CaHandlingApprox;

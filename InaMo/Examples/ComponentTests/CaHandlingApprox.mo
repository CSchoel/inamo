within InaMo.Examples.ComponentTests;
model CaHandlingApprox "unit test for CaHandling with approximated currents"
  extends Modelica.Icons.Example;
  import InaMo.Concentrations.Atrioventricular.CaHandling;
  import InaMo.Functions.Fitting.gaussianAmp;
  import InaMo.Concentrations.Interfaces.TransmembraneCaFlow;
  model DummyCaL "dummy model replacing I_Ca,L"
    extends TransmembraneCaFlow(n_ca=1);
    SI.Current i = gaussianAmp(time, y_min=0, y_max=-3e-10, x0=0.2, sigma=3.54e-3)
                 + gaussianAmp(time, y_min=0, y_max=-1e-10, x0=0.23, sigma=23.6e-3)
                 + gaussianAmp(time, y_min=0, y_max=-1e-10, x0=-0.1, sigma=118e-3);
    inner SI.Current i_ion = i;
  end DummyCaL;
  model DummyNaCa "dummy model replacing I_NaCa"
    extends TransmembraneCaFlow(n_ca=-2);
    SI.Current i = gaussianAmp(time, y_min=-0.5e-11, y_max=-4e-11, x0=0.2, sigma=3.54e-3)
                 + gaussianAmp(time, y_min=-0.5e-11, y_max=0.3e-11, x0=0.23, sigma=14.1e-3)
                 + gaussianAmp(time, y_min=0, y_max=-0.5e-10, x0=-0.1, sigma=118e-3);
    inner SI.Current i_ion = i;
  end DummyNaCa;
  DummyCaL cal "replacement for I_Ca,L"
     annotation(Placement(transformation(extent = {{-17, 31}, {17, 65}})));
  DummyNaCa naca "replacement for I_NaCa"
     annotation(Placement(transformation(extent = {{-65, 31}, {-31, 65}})));
  InaMo.Concentrations.Atrioventricular.CaHandling ca(
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
  ) "Ca2+ handling with same parameter settings as in NCell"
    annotation(Placement(transformation(extent = {{17, -17}, {51, 17}})));
  inner parameter SI.Volume v_sub = 3.1887126E-17 "volume of \"fuzzy\" subspace (value from C++ for N-cell)";
  inner parameter SI.Volume v_cyto = 1.43492067E-15 "volume of cytosol (value from C++ for N-cell)";
  inner parameter SI.Volume v_nsr = 3.698906616E-17 "volume of network SR (value from C++ for N-cell)";
  inner parameter SI.Volume v_jsr = 3.82645512E-18 "volume of junctional SR (value from C++ for N-cell)";
  inner parameter SI.Concentration ca_ex = 0 "extracellular Ca2+ concentration (value not used in this simulation)";
equation
  connect(cal.ca, ca.ca_sub) annotation(
    Line(points = {{6, 32}, {6, 32}, {6, 0}, {18, 0}, {18, 0}}));
  connect(naca.ca, ca.ca_sub) annotation(
    Line(points = {{-42, 32}, {-42, 32}, {-42, 0}, {18, 0}, {18, 0}}));
annotation(
  experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-7, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="(cal|naca)\\.i|ca\\.(sub|cyto|jsr|nsr)\\.con"),
  Documentation(info="<html>
    <p>This experiment approximates the behavior of the Ca2+ concentration in
    InaMo.Cells.Atrioventricular.NCell during a spontaneous action potential.
    </p>
    <p>In order to examine the behavior of
    InaMo.Concentrations.Atrioventricular.CaHandling in isolation, dummy
    currents are defined as a rough approximation of I_Ca,L and I_NaCa during
    a spontaneous AP.</p>
  </html>")
);
end CaHandlingApprox;

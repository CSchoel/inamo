within InaMo.Examples;
model SustainedInwardIV "try tro recreate figure 2 B from lindblad 1997"
  extends IVBase(
    vc(v_hold=-0.08, T_hold=4, T_pulse=0.5),
    v_start = -0.08,
    v_inc = 0.005
  );
  SustainedInwardChannel st;
  // TODO current density in plots of Inada 2009 is higher, but our model
  // is in accordance with Kurata 2002 => difference must be due to parameters
  LipidBilayer l2(use_init=false, C=29e-12);
equation
  connect(l2.p, st.p);
  connect(l2.n, st.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
annotation(
  experiment(StartTime = 0, StopTime = 80, Tolerance = 1e-12, Interval = 1e-3),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>

    </html>
  ")
);
end SustainedInwardIV;

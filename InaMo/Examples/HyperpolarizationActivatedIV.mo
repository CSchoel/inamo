within InaMo.Examples;
model HyperpolarizationActivatedIV "IV relationship of I_f, recreates figures S4C and S4D from Inada 2009"
  extends IVBase(
    vc(v_hold=-0.05, T_hold=20, T_pulse=4),
    v_start = -0.12,
    v_inc = 0.005
  );
  HyperpolarizationActivatedChannel f;
  LipidBilayer l2(use_init=false, C=29e-12);
equation
  connect(l2.p, f.p);
  connect(l2.n, f.n);
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
end HyperpolarizationActivatedIV;

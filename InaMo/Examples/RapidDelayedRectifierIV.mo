within InaMo.Examples;
model RapidDelayedRectifierIV "IV relationship of I_K,r, recteates Figure S3C-S3E"
  extends IVBase(
    vc(v_hold=-0.04, T_hold=5, T_pulse=0.5),
    v_start = -0.06,
    v_inc = 0.005
  );
  RapidDelayedRectifierChannel kr(G_max=1.5e-9) "I_K,r channel with parameters of AN cell model";
  LipidBilayer l2(use_init=false, C=40e-12);
equation
  connect(l2.p, kr.p);
  connect(l2.n, kr.n);
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
end RapidDelayedRectifierIV;

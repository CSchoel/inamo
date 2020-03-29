within InaMo.Examples;
model LTypeCalciumIV "IV relationship of I_Ca,L, recreates Figure S1E and S1H of Inada 2009"
  extends IVBase(
    vc(v_hold=-0.09, T_hold=5, T_pulse=0.3),
    v_start = -0.06,
    v_inc = 0.005
  );
  replaceable LTypeCalciumChannel cal(G_max=21e-9) "calcium channels with parameters from NH model";
  ConstantConcentration ca "calcium concentration that is affected by channel";
  LipidBilayer l2(use_init=false, C=40e-12);
equation
  connect(l2.p, cal.p);
  connect(l2.n, cal.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(cal.c_sub, ca.c);
annotation(
  experiment(StartTime = 0, StopTime = 155, Tolerance = 1e-12, Interval = 1e-2),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>

    </html>
  ")
);
end LTypeCalciumIV;

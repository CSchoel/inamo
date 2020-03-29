within InaMo.Examples;
model LTypeCalciumIV "try tro recreate figure 2 B from lindblad 1997"
  // TODO how long do we need T_pulse to be?
  extends IVBase(
    vc(v_hold=-0.09, T_hold=20, T_pulse=5),
    v_start = -0.1,
    v_inc = 0.005
  );
  replaceable LTypeCalciumChannel cal;
  ConstantConcentration ca "calcium concentration that is affected by channel";
  LipidBilayer l2(use_init=false, C=5e-11);
equation
  connect(l2.p, cal.p);
  connect(l2.n, cal.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  connect(cal.c_sub, ca.c);
annotation(
  experiment(StartTime = 0, StopTime = 80, Tolerance = 1e-12, Interval = 1e-3),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>

    </html>
  ")
);
end LTypeCalciumIV;

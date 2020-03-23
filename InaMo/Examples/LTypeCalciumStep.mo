within InaMo.Examples;
model LTypeCalciumStep "try tro recreate figure 1H from inada 2009"
  LTypeCalciumChannel cal;
  ConstantConcentration ca;
  LipidBilayer l2(use_init=false, C=40e-12);
  VoltageClamp vc(v_stim=if time < 1 then -0.04 else 0.01);
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
end LTypeCalciumStep;

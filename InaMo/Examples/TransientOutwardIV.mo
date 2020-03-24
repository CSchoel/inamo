within InaMo.Examples;
model TransientOutwardIV "try tro recreate figure 2 B from lindblad 1997"
  TransientOutwardChannel to;
  LipidBilayer l2(use_init=false, C=40e-12);
  // TODO how long do we need T_pulse to be?
  VoltageTestPulses vc(v_hold=-0.08, T_hold=4, T_pulse=0.5);
  parameter SI.Voltage v_start = -0.06 "start value for pulse amplitude";
  parameter SI.Voltage v_inc = 0.005 "increment for pulse amplitude";
  discrete SI.Current i(start=0, fixed=true);
  Real peak_i(start=0, fixed=true);
  discrete Real cd(unit="A/F") = i / l2.C "current density";
  discrete Boolean peak_indicator(start=false, fixed=true) = der(vc.i) < 0 "forces event at peak";
  Real pulse_last(start=0, fixed=true);
initial equation
  vc.v_pulse = v_start;
equation
  connect(l2.p, to.p);
  connect(l2.n, to.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  when vc.pulse_start then
    peak_i = 0;
  elsewhen change(peak_indicator) and time - pre(pulse_last) < vc.T_pulse then
    peak_i = if abs(vc.i)  > abs(pre(peak_i)) then vc.i else pre(peak_i);
  end when;
  when vc.pulse_start then
    i = pre(peak_i);
    pulse_last = time;
  end when;
  when vc.pulse_end then
    vc.v_pulse = pre(vc.v_pulse) + v_inc;
  end when;
annotation(
  experiment(StartTime = 0, StopTime = 80, Tolerance = 1e-12, Interval = 1e-3),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>

    </html>
  ")
);
end TransientOutwardIV;

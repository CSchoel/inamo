within InaMo.Examples;
model SustainedInwardIV "try tro recreate figure 2 B from lindblad 1997"
  SustainedInwardChannel st;
  // TODO current density in plots of Inada 2009 is higher
  LipidBilayer l2(use_init=false, C=29e-12);
  VoltageTestPulses vc(v_hold=-0.08, T_hold=4, T_pulse=0.5);
  parameter SI.Voltage v_start = -0.08 "start value for pulse amplitude";
  parameter SI.Voltage v_inc = 0.005 "increment for pulse amplitude";
  discrete SI.Current is_peak(start=0, fixed=true);
  discrete SI.Current is_tail(start=0, fixed=true);
  discrete SI.Current is_end(start=0, fixed=true);
  Real peak_i(start=0, fixed=true);
  Real tail_i(start=0, fixed=true);
  discrete Boolean peak_indicator(start=false, fixed=true) = der(vc.i) < 0 "forces event at peak";
  Real pulse_last(start=0, fixed=true);
initial equation
  vc.v_pulse = v_start;
equation
  connect(l2.p, st.p);
  connect(l2.n, st.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  when vc.pulse_start then
    peak_i = 0;
  elsewhen change(peak_indicator) and time - pre(pulse_last) < vc.T_pulse then
    peak_i = if abs(vc.i)  > abs(pre(peak_i)) then vc.i else pre(peak_i);
  end when;
  when vc.pulse_end then
    tail_i = 0;
  elsewhen change(peak_indicator) and time - pre(pulse_last) > vc.T_pulse and time - pre(pulse_last) < 2 * vc.T_pulse then
    tail_i = if abs(vc.i) > abs(pre(tail_i)) then vc.i else pre(tail_i);
  end when;
  when vc.pulse_start then
    pulse_last = time;
  end when;
  when vc.pulse_end then
    is_tail = pre(tail_i);
    vc.v_pulse = pre(vc.v_pulse) + v_inc;
    is_end = pre(vc.i);
    is_peak = pre(peak_i);
  end when;
annotation(
  experiment(StartTime = 0, StopTime = 80, Tolerance = 1e-12, Interval = 1e-3),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>

    </html>
  ")
);
end SustainedInwardIV;

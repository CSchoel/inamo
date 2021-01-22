within InaMo.Components.ExperimentalMethods;
model VCTestPulsesPeak "voltage clamp with test pulse protocol and peak capture"
  extends VCTestPulses;
  discrete SI.Current is_peak(start=0, fixed=true, nominal=1e-12) "steady step function of peak current during last pulse";
  discrete SI.Current is_tail(start=0, fixed=true, nominal=1e-12) "steady step function of peak tail current after last pulse";
  discrete SI.Current is_end(start=0, fixed=true, nominal=1e-12) "steady step function of current at end of last pulse";
  discrete SI.Voltage vs_peak(start=0, fixed=true) "steady step function of pulse associated with is_peak";
  discrete SI.Voltage vs_end(start=0, fixed=true) "steady step function of pulse associated with is_end";
  discrete SI.Voltage vs_tail(start=0, fixed=true) "steady step function of pulse associated with is_tail";
protected
  discrete SI.Current peak_i(start=0, fixed=true, nominal=1e-12) "peak current during pulse";
  discrete SI.Current tail_i(start=0, fixed=true, nominal=1e-12) "peak current after pulse";
  Boolean peak_indicator(start=false, fixed=true) = der(i) * 1e12 < 0 "forces event at peak (factor of 1e12 is required to detect zero crossing)";
  discrete SI.Time tp_last(start=0, fixed=true) "time stamp of start of last pulse";
  discrete SI.Voltage vp_last(start=0, fixed=true) "voltage of last pulse";
  Boolean within_pulse = time - pre(tp_last) < d_pulse "true during pulse";
  Boolean after_pulse = time - pre(tp_last) > d_pulse "true after pulse has passed";
  function absmax "returns input whose absolute value is larger"
    input Real a "first input";
    input Real b "second input";
    output Real m "a if abs(a) > abs(b), otherwise b";
  algorithm
    m := if abs(a) > abs(b) then a else b;
  end absmax;
equation
  when pulse_start then
    peak_i = 0;
  elsewhen change(peak_indicator) and within_pulse then
    peak_i = absmax(i, pre(peak_i));
  end when;
  when pulse_end then
    tail_i = 0;
  elsewhen change(peak_indicator) and after_pulse then
    tail_i = absmax(i, pre(tail_i));
  end when;
  when pulse_start then
    is_tail = pre(tail_i);
    vs_tail = pre(vp_last);
    tp_last = time;
    vp_last = v_pulse;
  end when;
  when pulse_end then
    is_end = pre(i);
    is_peak = pre(peak_i);
    vs_end = vp_last;
    vs_peak = vs_end;
  end when;
annotation(Documentation(info="<html>
  <p></p>
</html>"));
end VCTestPulsesPeak;

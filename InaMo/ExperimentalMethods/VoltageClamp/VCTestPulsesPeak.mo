within InaMo.ExperimentalMethods.VoltageClamp;
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
  function absmax "returns input whose absolute value is larger, preserving the sign"
    input Real a "first input";
    input Real b "second input";
    output Real m "a if abs(a) > abs(b), otherwise b";
  algorithm
    m := if abs(a) > abs(b) then a else b;
  end absmax;
equation
  when pulse_start then
    peak_i = i;
  elsewhen change(peak_indicator) and within_pulse or pulse_end then
    peak_i = absmax(i, pre(peak_i));
  end when;
  when pulse_end then
    tail_i = i;
  elsewhen change(peak_indicator) and after_pulse or pulse_end then
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
  <p>Ths model extends VCTestPulses with the capability to capture three
  different types of peak currents:</p>
  <ul>
    <li>&quot;peak&quot;: The peak current achieved between pulse_start and
      pulse_end, i.e. <i>during</i> the pulse</li>
    <li>&quot;tail&quot: The peak current achieved between pulse_end and the
      next pulse_start, i.e. <i>after</i> the pulse</li>
    <li>&quot;end&quot;: The current achieved at pulse_end</li>
  </ul>
  <p>The word &quot;peak&quot; in these descriptions refers to the farthest
  distance to zero achieved during the respective time period.
  This can either be the global maximum or the global minimum.</p>
  <p>Consequently, all three current measures (is_peak, is_tail, and is_end)
    capture the information of the last pulse cycle.
    is_end and is_peak are updated at pulse_end and is_tail is updated at
    pulse_start.</p>
  <p>For plotting convenience, the variables vs_peak, vs_tail, and vs_end
    capture the voltages of the pulse associated with the current measurement
    in is_peak, is_tail, and is_end respectively.
    A parametric current-voltage plot then becomes possible by just plotting
    a pair like (is_peak, vs_peak) without having to process the simulation
    output.</p>
</html>"));
end VCTestPulsesPeak;

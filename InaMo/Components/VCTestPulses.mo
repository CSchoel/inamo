within InaMo.Components;
model VCTestPulses "voltage clamp that sends periodic test pulses"
  extends VoltageClamp(v_stim(start=v_hold, fixed=true));
  parameter SI.Voltage v_hold = -0.090;
  parameter SI.Duration T_hold = 2;
  parameter SI.Duration T_pulse = 0.050;
  output Boolean pulse_start = sample(T_hold, T_hold);
  output Boolean pulse_end = sample(T_hold + T_pulse, T_hold);
  discrete input SI.Voltage v_pulse;
equation
  when pulse_start then
    reinit(v_stim, v_pulse);
  elsewhen pulse_end then
    reinit(v_stim, v_hold);
  end when;
  der(v_stim) = 0;
end VCTestPulses;
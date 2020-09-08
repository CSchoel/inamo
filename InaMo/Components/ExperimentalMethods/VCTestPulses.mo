within InaMo.Components.ExperimentalMethods;
model VCTestPulses "voltage clamp that sends periodic test pulses"
  extends VoltageClamp;
  extends TestPulses;
  parameter SI.Voltage v_hold = -0.090;
  discrete input SI.Voltage v_pulse;
equation
  v_stim = pulse_signal * (v_pulse - v_hold) + v_hold;
end VCTestPulses;

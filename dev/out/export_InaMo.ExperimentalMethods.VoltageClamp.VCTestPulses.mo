model VCTestPulses "voltage clamp that sends periodic test pulses"
  extends VoltageClamp;
  extends InaMo.ExperimentalMethods.Interfaces.TestPulses;
  parameter SI.Voltage v_hold = -0.090 "voltage during holding period";
  discrete input SI.Voltage v_pulse "voltage during pulse (must be defined externally)";
equation
  v_stim = pulse_signal * (v_pulse - v_hold) + v_hold;
end VCTestPulses;
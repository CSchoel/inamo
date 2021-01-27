within InaMo.ExperimentalMethods.CurrentClamp;
model CCTestPulses "current clamp that sends periodic test pulses"
  extends CurrentClamp;
  extends TestPulses;
  parameter SI.Current i_hold = 0 "current during holding period";
  // FIXME cannot be discrete in OpenModelica, but should be
  input SI.Current i_pulse "current during pulse (must be defined externally)";
equation
  i_stim = pulse_signal * (i_pulse - i_hold) + i_hold;
end CCTestPulses;

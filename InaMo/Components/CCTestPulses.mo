within InaMo.Components;
model CCTestPulses
  extends Modelica.Electrical.Analog.Interfaces.TwoPin;
  extends TestPulses;
  parameter SI.Current i_hold;
  discrete input SI.Current i_pulse;
equation
  i_stim = pulse_signal * (i_pulse - i_hold) + i_hold;
end CCTestPulses;

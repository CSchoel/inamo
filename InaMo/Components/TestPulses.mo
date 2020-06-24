within InaMo.Components;
model TestPulses "generic component to generate a dimensionless pulse signal"
  parameter SI.Duration d_hold = 2;
  parameter SI.Duration d_pulse = 0.050;
  output Boolean pulse_start = sample(d_hold, d_hold);
  output Boolean pulse_end = sample(d_hold + d_pulse, d_hold);
  output Integer pulse_signal(start=0, fixed=true);
equation
  when pulse_start then
    pulse_signal = 1;
  elsewhen pulse_end then
    pulse_signal = 0;
  end when;
end TestPulses;

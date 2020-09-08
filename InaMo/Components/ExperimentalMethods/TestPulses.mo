within InaMo.Components.ExperimentalMethods;
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
annotation(
  Icon(graphics = {
    Line(
      origin = {-55.7024, -80.0376},
      points = {{-40.2575, -14}, {-20.2575, -14}, {-20.2575, 14}, {-16.2575, 14}, {-16.2575, -14}, {-0.257485, -14}, {-0.257485, 14}, {3.74251, 14}, {3.74251, -14}, {19.7425, -14}, {19.7425, 14}, {23.7425, 14}, {23.7425, -14}, {37.7425, -14}},
      color = {0, 0, 255}
    )
  })
);
end TestPulses;

model TestPulses "generic component to generate a dimensionless pulse signal"
  parameter SI.Duration d_hold = 2 "holding period";
  parameter SI.Duration d_pulse = 0.050 "pulse period";
  output Boolean pulse_start = sample(d_hold, d_hold + d_pulse) "signals start of pulse";
  output Boolean pulse_end = sample(d_hold + d_pulse, d_hold + d_pulse) "signals end of pulse";
  output Integer pulse_signal(start = 0, fixed = true) "0 during holding period, 1 during pulse";
equation
  when pulse_start then
    pulse_signal = 1;
  elsewhen pulse_end then
    pulse_signal = 0;
  end when;
  annotation(
    Documentation(info = "<html>
    <p>
      This model generates a pulse_signal that stays zero for d_hold seconds
      and then switches to one for a duration of d_pulse, repeating the cycle
      with another zero period of d_hold seconds and another pulse of d_pulse
      seconds.
    </p>
    <p>
      The pulse_signal can be used to facilitate building pulse protocols by
      simply using the formula x = x_hold + pulse_signal * (x_pulse - x_hold)
      where x is the resulting pulse signal and x_hold is the value of x
      during the holding period and x_pulse is the value of x during the pulse.
    </p>
  </html>"),
    Icon(graphics = {Line(origin = {-55.7024, -80.0376}, points = {{-40.2575, -14}, {-20.2575, -14}, {-20.2575, 14}, {-16.2575, 14}, {-16.2575, -14}, {-0.257485, -14}, {-0.257485, 14}, {3.74251, 14}, {3.74251, -14}, {19.7425, -14}, {19.7425, 14}, {23.7425, 14}, {23.7425, -14}, {37.7425, -14}}, color = {0, 0, 255})}));
end TestPulses;
within InaMo.Examples;
partial model IVBase "base for all experiments for current-voltage relationship"
  extends InaMo.Icons.PartialExample;
  InaMo.Components.ExperimentalMethods.VCTestPulsesPeak vc
    annotation(Placement(transformation(extent={{-17, -17}, {17, 17}})));
  parameter SI.Voltage v_start = -0.08 "start value for pulse amplitude";
  parameter SI.Voltage v_inc = 0.005 "increment for pulse amplitude";
initial equation
  vc.v_pulse = v_start;
equation
  when vc.pulse_end then
    vc.v_pulse = pre(vc.v_pulse) + v_inc;
  end when;
annotation(
  Documentation(info="
    <html>
      <p>This model can be used as a basis for experiments that capture the
      current-voltage relationship of a single channel or ion pump.
      It will use a voltage clamp test pulse protocol with pulse amplitudes
      starting from v_start and continuously increasing by v_inc with each
      pulse.</p>
      <p>To calculate the correct StopTime needed for the simulation of pulses
      starting with v_start and ending with v_end, you can use the following
      formula:</p>
      <code>
        StopTime = ((v_end - v_start) / v_inc + 3) * (d_hold + d_pulse)
      </code>
      <p>The offset of 3 * (d_hold + d_pulse) is required because the first
      value for vc.is_peak, vc.is_end and vc.is_tail is obtained after
      2 * d_hold and the last value is obtained d_hold seconds after the
      pulse with amplitude v_end.</p>
      <p>d_pulse and d_hold should either be chosen according to reference or
      roughly such that d_pulse > 5 * tau_act and d_hold > 5 * tau_inact where
      tau_act is the time constant of the activation and tau_inact is the time
      constant of inactivation of the simulated channel.
      This ensures that there is enough time to observe the characteristic
      time course of activation and inactivation and that the channel is close
      to its steady state at holding potential before the next pulse.</p>
    </html>
  ")
);
end IVBase;

within InaMo.Examples;
partial model IVBase "base for all experiments for current-voltage relationship"
  VCTestPulsesPeak vc;
  parameter SI.Voltage v_start = -0.08 "start value for pulse amplitude";
  parameter SI.Voltage v_inc = 0.005 "increment for pulse amplitude";
initial equation
  vc.v_pulse = v_start;
equation
  when vc.pulse_end then
    vc.v_pulse = pre(vc.v_pulse) + v_inc;
  end when;
end IVBase;

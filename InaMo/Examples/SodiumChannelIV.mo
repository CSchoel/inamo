within InaMo.Examples;
model SodiumChannelIV "try tro recreate figure 2 B from lindblad 1997"
  SodiumChannel na(
    ion=sodium,
    T=T
  );
  LipidBilayer l2(use_init=false);
  // Note: uses Lindblad parameters instead of Inada parameters
  // For Inada2009 we would use MobileIon(8, 140, 1.4e-9, 1) at 310K
  parameter MobileIon sodium = MobileIon(8.4, 75, 1.4e-9*1.5, 1);
  parameter Real T = SI.Conversions.from_degC(35);
  VoltageTestPulses vc(v_hold=-0.09, T_hold=2, T_pulse=0.05);
  parameter SI.Voltage v_start = -0.1 "start value for pulse amplitude";
  parameter SI.Voltage v_inc = 0.005 "increment for pulse amplitude";
  discrete SI.Current i(start=0, fixed=true);
  // FIXME: magnitude of cd is still fishy
  discrete Real cd(unit="A/F") = i / l2.C "current density";
  Real min_i(start=0, fixed=true) = min(pre(min_i), vc.i);
  Real max_i(start=0, fixed=true) = max(pre(max_i), vc.i);
initial equation
  vc.v_pulse = v_start;
equation
  connect(l2.p, na.p);
  connect(l2.n, na.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
  when vc.pulse_start then
    if pre(max_i) < 1e-6 then
      i = pre(min_i);
    else
      i = pre(max_i);
    end if "use maximum if nonzero, else use minimum";
    reinit(min_i, 0);
    reinit(max_i, 0);
  end when;
  when vc.pulse_end then
    vc.v_pulse = pre(vc.v_pulse) + v_inc;
  end when;
annotation(
  experiment(StartTime = 0, StopTime = 80, Tolerance = 1e-12, Interval = 1e-4),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To reproduce Figure 2B from Lindblad 1997, plot cd against
      (v_pulse - v_inc).
      It is necessary to subtract v_inc, because cd captures the current
      density from the <i>previous</i> pulse.</p>
      <p>Note that results will not be exact as Lindblad 1997 used the full
      model to generate the plots.</p>
      <p>Note about experiment setup: Noble 1962 remarks that 0.1 ms is the
      smallest step size needed for RK4. Tolerance is chosen to capture
      changes of a single pico Ampere.</p>
    </html>
  ")
);
end SodiumChannelIV;

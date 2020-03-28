within InaMo.Examples;
model SodiumChannelIV "try tro recreate figure 2 B from lindblad 1997"
  extends IVBase(
    vc(v_hold=-0.09, T_hold=2, T_pulse=0.05),
    v_start = -0.1
  );
  SodiumChannel na(ion=sodium, T=T);
  LipidBilayer l2(use_init=false, C=5e-11);
  // Note: uses Lindblad parameters instead of Inada parameters
  // For Inada2009 we would use MobileIon(8, 140, 1.4e-15, 1) at 310K
  // Note: pl/s -> m³/s by setting p *= 1e-15
  parameter MobileIon sodium(c_in=8.4, c_ex=75, p=1.4e-15*1.5, z=1);
  parameter Real T = SI.Conversions.from_degC(35);
  // FIXME: magnitude of cd is still fishy
  discrete Real cd(unit="A/F") = vc.is_peak / l2.C "current density";
equation
  connect(l2.p, na.p);
  connect(l2.n, na.n);
  connect(l2.p, vc.p);
  connect(l2.n, vc.n);
annotation(
  experiment(StartTime = 0, StopTime = 80, Tolerance = 1e-12, Interval = 1e-3),
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
      <p>Parameter Settings can be found in Lindblad 1997 on the following
      pages:</p>
      <ul>
        <li>sodium.c_in: H1673 (Table 15, initial value)</li>
        <li>sodium c_ex: H1674 (Fig. 2)</li>
        <li>sodium.p: H1672 (Table 14) + H1673 (top right) + Inada 2009 Supporting material, 27</li>
        <li>T: H1674 (Fig 2.)</li>
        <li>l2.C: H1672 (Table 14)</li>
        <li>vc.v_hold: H1674 (Fig. 2)</li>
        <li>vc.T_hold: H1674 (Fig. 2) -> Wendt 1992, C1235 (bottom left)</li>
        <li>vc.T_pulse: H1674 (Fig. 2) -> Wendt 1992, C1235 (bottom left)</li>
      </ul>
      <p>sodium.p is the only parameter whose value is not directly taken from
      Lindblad 1997. Lindblad et al. use 1.4 nl while Inada et al. use 1.4 pl
      which gives currents in the order of nA instead of μa and therefore
      seems more reasonable (and is more in accordance with the plots of
      Lindblaf et al.).</p>
    </html>
  ")
);
end SodiumChannelIV;

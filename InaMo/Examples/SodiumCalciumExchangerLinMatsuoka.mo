within InaMo.Examples;
model SodiumCalciumExchangerLinMatsuoka "bundles all experiments required to reproduce Figure 19 of Matsuoka 1992"
  model BundleBase = SodiumCalciumExchangerLin(
      naca(k_NaCa=1e-9),
      l2(T_m=307.52),
      v_start=-140e-3
  );
  BundleBase a1(sodium(c_in=25, c_ex=0), ca_sub(c_const=0), calcium(c_ex=8), naca(k_NaCa=1e-9));
  BundleBase a2(sodium(c_in=25, c_ex=0), ca_sub(c_const=0.016), calcium(c_ex=8), naca(k_NaCa=1e-9));
  BundleBase a3(sodium(c_in=25, c_ex=0), ca_sub(c_const=0.234), calcium(c_ex=8), naca(k_NaCa=1e-9));
  BundleBase b1(sodium(c_in=100, c_ex=0), ca_sub(c_const=0), calcium(c_ex=8), naca(k_NaCa=0.25e-9));
  BundleBase b2(sodium(c_in=100, c_ex=0), ca_sub(c_const=0.064), calcium(c_ex=8), naca(k_NaCa=0.25e-9));
  BundleBase b3(sodium(c_in=100, c_ex=0), ca_sub(c_const=1.08), calcium(c_ex=8), naca(k_NaCa=0.25e-9));
  BundleBase c1(sodium(c_in=0, c_ex=150), ca_sub(c_const=0.003), calcium(c_ex=0), naca(k_NaCa=0.33e-9));
  BundleBase c2(sodium(c_in=25, c_ex=150), ca_sub(c_const=0.003), calcium(c_ex=0), naca(k_NaCa=0.33e-9));
  BundleBase c3(sodium(c_in=50, c_ex=150), ca_sub(c_const=0.003), calcium(c_ex=0), naca(k_NaCa=0.33e-9));
  BundleBase d1(sodium(c_in=0, c_ex=150), ca_sub(c_const=1.08), calcium(c_ex=0), naca(k_NaCa=0.5e-9));
  BundleBase d2(sodium(c_in=25, c_ex=150), ca_sub(c_const=1.08), calcium(c_ex=0), naca(k_NaCa=0.5e-9));
  BundleBase d3(sodium(c_in=100, c_ex=150), ca_sub(c_const=1.08), calcium(c_ex=0), naca(k_NaCa=0.5e-9));
annotation(
  experiment(StartTime = 0, StopTime = 280, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To recreate Figure 19 of Matsuoka 1992, plot the following variables
      against a1.vc.v.<p>
      <ul>
        <li>Figure 19A: a1.naca.i, a2.naca.i, a3.naca.i</li>
        <li>Figure 19B: b1.naca.i, b2.naca.i, b3.naca.i</li>
        <li>Figure 19C: c1.naca.i, c2.naca.i, c3.naca.i</li>
        <li>Figure 19D: d1.naca.i, d2.naca.i, d3.naca.i</li>
      </ul>
      <p>The values for the concentration parameters are chosen as follows:</p>
      <ul>
        <li>Figure 19A
          <ul>
            <li>sodium.c_ex = 0 <i>(according to Figure 15A)</i></li>
            <li>sodium.c_in = 25</li>
            <li>calcium.c_ex = 8 <i>(according to Figure 15A)</i></li>
            <li>ca_sub.c_const = [0, 0.016, 0.234]</li>
          </ul>
        </li>
        <li>Figure 19B
          <ul>
            <li>sodium.c_ex = 0 <i>(according to Figure 15A and p. 983, paragraph about Figure 16A)</i></li>
            <li>sodium.c_in = 100</li>
            <li>calcium.c_ex = 8 <i>(according to Figure 15A and p. 983, paragraph about Figure 16A)</i></li>
            <li>ca_sub.c_const = [0, 0.064, 1.08]</li>
          </ul>
        </li>
        <li>Figure 19C
          <ul>
            <li>sodium.c_ex = 150 <i>(according to Figure 17A)</i></li>
            <li>sodium.c_in = [0, 25, 50]</li>
            <li>calcium.c_ex = 0 <i>(according to Figure 17A)</i></li>
            <li>ca_sub.c_const = 0.003</li>
          </ul>
        </li>
        <li>Figure 19D
          <ul>
            <li>sodium.c_ex = 150 <i>(according to Figure 17B)</i></li>
            <li>sodium.c_in = [0, 25, 100]</li>
            <li>calcium.c_ex = 0 <i>(according to Figure 17B)</i></li>
            <li>ca_sub.c_const = 1.08</li>
          </ul>
        </li>
      </ul>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -140 to +140 mV</li>
        <li>Tolerance: left at default value because derivatives are not
        relevant</li>
        <li>Interval: enough for a smooth plot</li>
        <li>l2.C: left at default value for AN cell because it is not relevant
        for the plot</li>
        <li>naca.k_NaCa: chosen arbitrarily to fit order of magnitude for
        individual subplots of Figure 19 of Matsuoka 1992 (see note below)</li>
        <li>L2.T_m: according to Matsuoka 1992, p. 993 (2 * RT/F = 53 mV <=>
        T = 307.52 °K</li>
      </ul>
      <p>For more details of parameter and simulation settings see the
      documentation of InaMo.Examples.SodiumCalciumExchangerLin.</p>
      <p>NOTE: Matsuoka et al. never give a value for l2.C, because when the
      voltage is fixed with a voltage clamp, the capacitance of the cell
      has no influence on the resulting current. We therefore leave l2.C
      arbitrarily at the default value for AN cells.</p>
      <p>NOTE: The subplots in Figure 19 of Matsuoka 1992 cannot be
      reproduced with a single value for naca.k_NaCa. This is hinted at on
      page 993 of Matsuoka 1992, where the authors state that &quot;each
      experiment was fitted with a scaler variable&quot;. Unfortunately the
      values of these variables are not given in the paper. We therefore
      chose arbitrary values between 0.25 and 1 nA to roughly fit the order
      of magnitude of the experimental data.</p>
    </html>
  ")
);
end SodiumCalciumExchangerLinMatsuoka;

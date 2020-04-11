within InaMo.Examples;
model SodiumCalciumExchangerLinMatsuoka "bundles all experiments required to reproduce Figure 19 of Matsuoka 1992"
  model BundleBase = SodiumCalciumExchangerLin(
      naca(k_NaCa=1e-9),
      l2(T_m=307.52),
      v_start=-140e-3
  );
  BundleBase a1(sodium(c_in=25, c_ex=0), ca_sub(c_const=0), calcium(c_ex=8));
  BundleBase a2(sodium(c_in=25, c_ex=0), ca_sub(c_const=0.016), calcium(c_ex=8));
  BundleBase a3(sodium(c_in=25, c_ex=0), ca_sub(c_const=0.234), calcium(c_ex=8));
  BundleBase b1(sodium(c_in=100, c_ex=0), ca_sub(c_const=0), calcium(c_ex=8));
  BundleBase b2(sodium(c_in=100, c_ex=0), ca_sub(c_const=0.064), calcium(c_ex=8));
  BundleBase b3(sodium(c_in=100, c_ex=0), ca_sub(c_const=1.08), calcium(c_ex=8));
  BundleBase c1(sodium(c_in=0, c_ex=150), ca_sub(c_const=0.003), calcium(c_ex=0));
  BundleBase c2(sodium(c_in=25, c_ex=150), ca_sub(c_const=0.003), calcium(c_ex=0));
  BundleBase c3(sodium(c_in=50, c_ex=150), ca_sub(c_const=0.003), calcium(c_ex=0));
  BundleBase d1(sodium(c_in=0, c_ex=150), ca_sub(c_const=1.08), calcium(c_ex=0));
  BundleBase d2(sodium(c_in=25, c_ex=150), ca_sub(c_const=1.08), calcium(c_ex=0));
  BundleBase d3(sodium(c_in=100, c_ex=150), ca_sub(c_const=1.08), calcium(c_ex=0));
annotation(
  experiment(StartTime = 0, StopTime = 280, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To recreate Figure 19 of Matsuoka 1992, plot the following variables
      against a1.vc.v.<p>
      <ul>
        <li>Figure 19A: a1.vc.i, a2.vc.i, a3.vc.i</li>
        <li>Figure 19B: b1.vc.i, b2.vc.i, b3.vc.i</li>
        <li>Figure 19C: c1.vc.i, c2.vc.i, c3.vc.i</li>
        <li>Figure 19D: d1.vc.i, d2.vc.i, d3.vc.i</li>
      </ul>
      <p>For more details of parameter and simulation settings see the
      documentation of InaMo.Examples.SodiumCalciumExchangerLin.</p>
      <p>NOTE: Matsuoka et al. never give a value for l2.C, because when the
      voltage is fixed with a voltage clamp, the capacitance of the cell
      has no influence on the resulting current. We therefore leave l2.C
      arbitrarily at the default value for AN cells.</p>
    </html>
  ")
);
end SodiumCalciumExchangerLinMatsuoka;

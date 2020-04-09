within InaMo.Examples;
model SodiumCalciumExchangerLinKurata "IV relationship of I_NaCa, recreates Figure 17 from Kurata 2002"
  extends SodiumCalciumExchangerLin(
    l2(C=32e-12),
    naca(k_NaCa=125e-12),
    sodium(c_in=10, c_ex=140),
    calcium(c_ex=2),
    ca_sub(c_const=0.1e-3),
    v_start=-100e-3
  );
annotation(
  experiment(StartTime = 0, StopTime = 150, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To recreate Figure 17 of Kurata 2002, plot vc.i against vc.v.</p>
      <p>For more detail about the experiment setup see the documentation of
      InaMo.Examples.SodiumCalciumExchangerLin.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -100 to +50 mV</li>
        <li>Tolerance: left at default value because derivatives are not
        relevant</li>
        <li>Interval: enough for a smooth plot</li>
      </ul>
    </html>
  ")
);
end SodiumCalciumExchangerLinKurata;
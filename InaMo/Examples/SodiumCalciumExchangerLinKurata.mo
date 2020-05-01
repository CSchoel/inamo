within InaMo.Examples;
model SodiumCalciumExchangerLinKurata "IV relationship of I_NaCa, recreates Figure 17 from Kurata 2002"
  extends SodiumCalciumExchangerLin(
    l2(C=32e-12),
    T=310.15,
    naca(k_NaCa=125 * l2.C),
    sodium(c_in=10, c_ex=140),
    calcium(c_ex=2),
    ca_sub(c_const=0.1e-3),
    v_start=-100e-3
  );
annotation(
  experiment(StartTime = 0, StopTime = 150, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __ChrisS_testing(testedVariableFilter="naca\\.i|vc\\.v"),
  Documentation(info="
    <html>
      <p>To recreate Figure 17 of Kurata 2002, plot naca.i against vc.v.</p>
      <p>For more detail about the experiment setup see the documentation of
      InaMo.Examples.SodiumCalciumExchangerLin.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -100 to +50 mV</li>
        <li>Tolerance: left at default value because derivatives are not
        relevant</li>
        <li>Interval: enough for a smooth plot</li>
        <li>L2.C: according to Table A1 in Kurata 2002</li>
        <li>naca.k_NaCa: according to Table A1 in Kurata 2002 (see note below)
        </li>
        <li>sodium.c_in: according to description of Figure 17 of Kurata
        2002</li>
        <li>sodium.c_ex: according to Table A1 in Kurata 2002</li>
        <li>calcium.c_ex: according to Table A1 in Kurata 2002</li>
        <li>ca_sub.c_const: according to description of Figure 17 of Kurata
        2002</li>
      </ul>
      <p>NOTE: Kurata give k_NaCa as 125 1/pF (which should probably be
      125 pA/pF). This means that we have to multiply the value by l2.C to
      obtain the actual parameter in pA.</p>
      <p>NOTE: This is the only plot for I_NaCa where all relevant
      conventration parameters are given. Consequently this example can
      reproduce the Figure from the paper exactly while the others cannot.</p>
    </html>
  ")
);
end SodiumCalciumExchangerLinKurata;

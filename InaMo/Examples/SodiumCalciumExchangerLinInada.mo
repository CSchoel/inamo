within InaMo.Examples;
model SodiumCalciumExchangerLinInada "IV relationship of I_NaCa, recreates Figure S6B from Inada 2009"
  model BaseExample = SodiumCalciumExchangerLin(
    v_start=-80e-3,
    sodium(c_in=8, c_ex=140),
    calcium(c_ex=2.5),
    ca_sub(c_const=0.15e-3),
    l2(T_m=310)
  );
  BaseExample an_nh(
    naca(k_NaCa=5.92e-9),
    l2(C=40e-12)
  );
  BaseExample n(
    naca(k_NaCa=2.14e-9),
    l2(C=29e-12)
  );
annotation(
  experiment(StartTime = 0, StopTime = 140, Tolerance = 1e-6, Interval = 1),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To recreate Figure S6B of Inada 2009, plot an_nh.vc.i against
      an_nh.vc.v and n.vc.i against n.vc.v.</p>
      <p>This example is based on InaMo.Examples.SodiumCalciumExchangerLin.
      For details of the experiment setup see this base model.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow a plot from -80 to +60 mV</li>
        <li>Tolerance: left at default value because derivatives are not
        relevant</li>
        <li>Interval: enough for a smooth plot</li>
        <li>BaseExample.sodium.c_in: according to Table S15 of Inada 2009</li>
        <li>BaseExample.sodium.c_ex: according to Table S15 of Inada 2009</li>
        <li>BaseExample.calcium.c_ex: according to Convery 2000, p. 394
        (Tyrode's solution)</li>
        <li>BaseExample.ca_sub.c_const: found by manually changing value until
        plot matched Figure S6B of Inada 2009</li>
      </ul>
      <p>NOTE: Inada et al. do not state whether calcium concentration was held
      constant for the experiment and if so, which value was assumed for
      [Ca2+]_sub. We assume that they wanted to reproduce the results of
      Kurata 2002 and therefore assume a constant [Ca2+]_sub as given in the
      description of Figure 17 of Kurata 2002.</p>
    </html>
  ")
);
end SodiumCalciumExchangerLinInada;

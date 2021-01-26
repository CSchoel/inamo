within InaMo.Examples.ComponentTests;
model SodiumCalciumExchangerRampInada "IV relationship of I_NaCa, recreates Figure S6 from Inada 2009"
  extends Modelica.Icons.Example;
  model BaseExample = SodiumCalciumExchangerRamp(
    na_in=8, na_ex=140,
    ca_ex=2.5,
    ca_sub(c_const=0.15e-3),
    temp=310
  );
  BaseExample an_nh(
    naca(k_NaCa=5.92e-9),
    l2(c=40e-12)
  );
  BaseExample n(
    naca(k_NaCa=2.14e-9),
    l2(c=29e-12)
  );
//FIXME variableFilter behaves weird (also catches some F1_ variables)
annotation(
  experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-6, Interval = 1e-3),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  __MoST_experiment(variableFilter="(n|an_nh)\\.(vc\\.v|naca\\.(i|e[1-4]|k_[1-4][1-4]))"),
  Documentation(info="
    <html>
      <p>To recreate Figure S6A of Inada 2009, plot an_nh.naca.i / an_nh.l2.C
      against an_nh.vc.v and n.naca.i / n.l2.C against n.vc.v.</p>
      <p>To recreate Figure S6B of Inada 2009, plot an_nh.naca.i against
      an_nh.vc.v and n.naca.i against n.vc.v, choosing only the data from
      50 ms <= t < 300 ms.</p>
      <p>This example is based on InaMo.Examples.SodiumCalciumExchangerRamp.
      For details of the experiment setup see this base model.</p>
      <p>Simulation protocol and parameters are chosen with the following
      rationale:</p>
      <ul>
        <li>StopTime: allow to see the whole 300 ms ramp in the plot</li>
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
      [Ca2+]_sub. Since they used Data from Convery 2000 in Figure S6, we
      assume that the calcium and sodium concentrations should be similar to
      those used in this experiment ([Na+]_i = 10 mM, [Na+]_o = 140 mM,
      [Ca2+]_o = 2.5 mM). However, Convery 2000 do not give a value for
      [Ca2+]_sub and both using all values from Table S15 of Inada 2009 and
      using all values from Convery 2000 does not reproduce the absolute values
      observed in Figure S6. We therefore used a mix of settings from both
      sources and manually changed [Ca2+]_sub until a good fit with the plot
      was achieved.</p>
    </html>
  ")
);
end SodiumCalciumExchangerRampInada;

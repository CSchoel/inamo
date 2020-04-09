within InaMo.Examples;
model SodiumCalciumExchangerRampN "I_NaCa during voltage clamp ramp, recreates Figure S6A from Inada 2009, parameters for N cell model"
  extends SodiumCalciumExchangerRamp(
    l2(C=29e-12),
    naca(k_NaCa=2.14e-9),
    ca_sub(c_const=0.2294e-3)
  );
annotation(
  experiment(StartTime = 0, StopTime = 0.5, Tolerance = 1e-12, Interval = 1e-3),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl"),
  Documentation(info="
    <html>
      <p>To recreate Figure S6A of Inada 2009, plot vc.i / l2.C against
      vc.v.</p>
      <p>Simulation protocol and parameters are chosen with the same
      rationale as for InaMo.Examples.SodiumCalciumExchangerRamp but with
      values for N cell model instead of AN cell model.</p>
    </html>
  ")
);
end SodiumCalciumExchangerRampN;

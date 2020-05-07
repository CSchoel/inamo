package InaMo
  import SI = Modelica.SIunits;
  type PermeabilityFM = Real(
    final quantity="Permeability (fluid mechanics)",
    final unit="m3/(s.m2)"
  );
  constant SI.Area unitArea = 1;
annotation(
  Documentation(info="
    <html>
    <p>This package is a reproduction and refactoring of the one-dimensional
    model of the rabbit atrioventricular node published by Inada et al. in
    2009.</p>
    <p>NOTE: If you compare this implementation to the original paper you may
    notice several discepancies and/or missing information. In the following
    I will try to explain each of these issues as best as I can:</p>
    <ul>
      <li>Some parameters are not given in the supplement of Inada et al. and
      have to be obtained from other sources:
        <ul>
          <li>The parameters of InaMo.Components.IonConcentrations.CaHandling
          are taken from Kurata 2002 with the exception of
          CaHandling.cm_sl.c_tot which is called SL_tot in Inada 2009 but
          never given. We assumed that this parameter should be equal to
          [CM]_tot, i.e. CaHandling.cm_cyto.c_tot.
          </li>
          <li>InaMo.Components.IonChannels.SustainedInwardChannel.v_eq (E_st
          in Inada 2009) is taken from Kurata 2002.</li>
          <li>InaMo.Components.IonChannels.RapidDelayedRectifierChannel.v_eq
          (E_k in inada 2009) is calculated from [K+]_i and [K+]_o with the
          nernst equation.</li>
          <li>
          The parameters of InaMo.Components.IonChannels.SodiumCalciumExchanger
          are taken from Demir 1994 (who use the same values as Matsuoka 1992)
          with the exception of k_NaCa which is given by Inada 2009.
          </li>
          <li>InaMo.Components.IonChannels.SodiumChannel.na_p is taken from
          table S17 in Inada 2009 which is only supposed to be used for the
          atrial cell model. Here, Inada 2009 use a value of pl/s instead
          of nl/s, which is probbaly correcting an error in Lindblad 1997.</li>
        </ul>
      </li>
      <li>The starting values for activation and inactivation states do not
      seem to follow any clear pattern (such as using the steady state value
      at a certain voltage as in the classic Hodgkin-Huxley modle). We used
      the values by Inada et al. for the full cell models, but kept the
      default behavior to use the steady state at 0 mV.</li>
      <!-- TODO: weird units -->
    </ul>
    </html>
  ")
);
end InaMo;

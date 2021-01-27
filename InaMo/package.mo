package InaMo
  extends Modelica.Icons.Package;
  import SI = Modelica.SIunits;
  type PermeabilityFM = Modelica.Icons.TypeReal(
    final quantity="Permeability (fluid mechanics)",
    final unit="m3/(s.m2)"
  );
  constant SI.Area unitArea = 1;
annotation(
  uses(Modelica(version="3.2.3")),
  version="1.3.0",
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
          <li>The parameters of InaMo.Concentrations.Atrioventricular.CaHandling
          are taken from Kurata 2002 with the exception of
          CaHandling.cm_sl.c_tot which is called SL_tot in Inada 2009 but
          never given. We assumed that this parameter should be equal to
          [CM]_tot, i.e. CaHandling.cm_cyto.c_tot.
          </li>
          <li>InaMo.Currents.Atrioventricular.SustainedInwardChannel.v_eq (E_st
          in Inada 2009) is taken from Kurata 2002.</li>
          <li>InaMo.Currents.Atrioventricular.RapidDelayedRectifierChannel.v_eq
          (E_k in inada 2009) is calculated from [K+]_i and [K+]_o with the
          nernst equation.</li>
          <li>
          The parameters of InaMo.Currents.Atrioventricular.SodiumCalciumExchanger
          are taken from Demir 1994 (who use the same values as Matsuoka 1992)
          with the exception of k_NaCa which is given by Inada 2009.
          </li>
          <li>InaMo.Currents.Atrioventricular.SodiumChannel.na_p is calculated
          as na_p = g_na / na_ex * RT / (F^2) according to equation 13 in
          table S3.</li>
          <li>Starting values for the gating variables of
          InaMo.Currents.Atrioventricular.TransientOutwardChannel are mixed up in
          Table S16. Instead of q, r_fast, and r_slow they must be named
          r, q_fast, and q_slow respectively.</li>
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

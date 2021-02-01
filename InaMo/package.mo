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
      <li>InaMo contains an acetylcholine-sensitive potassium channel, which
      is present in the C++ implementation by Inada et al., but not in the
      original article.
      However, this channel is currently not used for simulations and we are
      not sure if it was activate in the Simulations by Inada et al..</li>
      <li>The Inada 2009 article contained some minor errors, which we
      corrected by consulting source articles, reference plots, or the C++
      implementation.
        <ul>
          <li>In the equation for the time constant of the fast inactivation
          gate of the transient outward current I_to, the constant 0.1266
          must be replaced with 0.01266 according to figure S2C.</li>
          <li>All alpha and beta variables for the sustained inward current
          I_st must be multiplied by a factor of 1/1000 according to C++ code
          and Kurata 2002.</li>
          <li>alpha_qa in the sustained inward current I_st must have a
          negative sign for the second V in the denominator according to
          Kurata 2002.</li>
          <li>f_CM_i and f_TC in the equation for d[Ca2+]_i/dt must enter with
          a negative sign according to Kurata 2002.</li>
          <li>Q_n in the equation for k_14 in I_NaCa should enter with a
          positive sign according to Kurata 2002.</li>
          <li>The parameters k_x and k_b_x, where x = f_CM, f_CQ, ... need
          to be multiplied by 1000 due to a unit conversion from 1/ms in
          Kurata 2002 to 1/s in Inada 2009.</li>
        </ul>
      </li>
      <li>Some parameters are not given in the supplement of Inada et al. and
      have to be obtained from other sources:
        <ul>
          <li>The parameters of InaMo.Concentrations.Atrioventricular.CaHandling
          are taken from Kurata 2002 with the exception of cm_sl.c_tot, which
          is called SL_tot in Inada 2009 but only given in the C++ code.
          </li>
          <li>InaMo.Currents.Atrioventricular.SustainedInwardChannel.v_eq (E_st
          in Inada 2009) is taken from Kurata 2002.</li>
          <li>InaMo.Currents.Atrioventricular.RapidDelayedRectifierChannel.v_eq
          (E_k in inada 2009) is calculated from [K+]_i and [K+]_o with the
          nernst equation.</li>
          <li>
          The parameters of InaMo.Currents.Atrioventricular.SodiumCalciumExchanger
          are taken from Dokos 1996 (who use the same values as Matsuoka 1992)
          with the exception of k_NaCa which is given by Inada 2009.
          </li>
          <li>InaMo.Currents.Atrioventricular.SodiumChannel.na_p is calculated
          as na_p = g_na / na_ex * RT / (F^2) according to equation 13 in
          table S3.</li>
          <!-- TODO: more general statement about starting values -->
          <li>Starting values for the gating variables of
          InaMo.Currents.Atrioventricular.TransientOutwardChannel are mixed up in
          Table S16. Instead of q, r_fast, and r_slow they must be named
          r, q_fast, and q_slow respectively.</li>
          <li>The C++ code contains an equation to determine the cell volume
          v_cell based on the membrane capacitance.
          This is used in conjunction with the equation from Kurata 2002, which
          defines the compartment volumes in terms of fractions of the toal
          cell volume.</li>
          <li>The parameters K_m,Na, and K_m,K in the equations for the sodium
          potassium pump I_p are taken from Zhang 2000.</li>
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

model SodiumCalciumExchanger "sodium-calcium exchanger (I_NaCa)"
  extends InaMo.Currents.Interfaces.OnePortVertical;
  extends InaMo.Concentrations.Interfaces.TransmembraneCaFlow(n_ca = -2);
  // ca_sub
  extends InaMo.Icons.InsideBottomOutsideTop;
  extends InaMo.Icons.LipidBilayerWithGap;
  extends InaMo.Icons.SodiumCalciumExchanger;
  extends InaMo.Icons.Current(current_name = "I_NaCa");
  type Fraction = Real(unit = "1", min = 0, max = 1, quantity = "fraction") "type denoting fractions between 0 and 1";
  inner SI.Current i_ion = i "current used for TransmembraneCaFlow";
  outer parameter SI.Concentration na_in "intracellular sodium concentration";
  outer parameter SI.Concentration na_ex "extracellular sodium concentration";
  outer parameter SI.Concentration ca_ex "extracellular calcium concentration";
  outer parameter SI.Temperature temp "cell medium temperature";
  outer parameter SI.Volume v_sub "volume of 'fuzzy' subspace";
  parameter SI.Concentration k_c_i = 0.0207 "dissociation constant for channel with Ca++ bound on inside";
  parameter SI.Concentration k_cn_i = 26.44 "dissociation constant for channel with Ca++ and one Na+ bound on inside";
  parameter SI.Concentration k_1n_i = 395.3 "dissociation constant for channel with one Na+ bound on inside";
  parameter SI.Concentration k_2n_i = 2.289 "dissociation constant for channel with two Na+ bound on inside";
  parameter SI.Concentration k_3n_i = 26.44 "dissociation constant for channel with three Na+ bound on inside";
  parameter SI.Concentration k_c_o = 3.663 "dissociation constant for channel with Ca++ bound on outside";
  parameter SI.Concentration k_1n_o = 1628 "dissociation constant for channel with one Na+ bound on outside";
  parameter SI.Concentration k_2n_o = 561.4 "dissociation constant for channel with two Na+ bound on outside";
  parameter SI.Concentration k_3n_o = 4.663 "dissociation constant for channel with three Na+ bound on outside";
  parameter Real q_ci = 0.1369 "fractional charge movement during intracellular Ca++ occlusion reaction";
  parameter Real q_co = 0 "fractional charge movement during extracellular Ca++ occlusion reaction";
  parameter Real q_n = 0.4315 "fractional charge movement during Na+ occlusion reactions";
  parameter SI.Current k_NaCa = 5.92e-9 "scaling factor for Na+/Ca++ exchanger current";
  Real di_c = ca.amount / v_sub / k_c_i "relative frequency of E1 states that are occupied by Ca2+ and not occluded";
  Real di_cv = di_c * exp(-q_ci * v * FoRT) "relative frequency of E1 states that are occupied by Ca2+ and occluded";
  Real di_cn = di_c * na_in / k_cn_i "relative frequency of E1 states whose first two binding sites are occupied by Ca2+ and whose last binding site is occupied by Na+";
  Real di_1n = na_in / k_1n_i "relative frequency of E1 states where only the first Na+ site is occupied by Na+";
  Real di_2n = di_1n * na_in / k_2n_i "relative frequency of E1 states where exactly the first two Na+ sites are occupied by Na+";
  Real di_3n = di_2n * na_in / k_3n_i "relative frequency of E1 states where exactly three Na+ sites are occupied by Na+";
  Real di = 1 + di_c + di_cv + di_cn + di_1n + di_2n + di_3n "common denominator summing relative frequencies for all E1 substates";
  Real do_c = ca_ex / k_c_o "relative frequency of E2 states that are occupied by Ca2+ and not occluded";
  Real do_cv = do_c * exp(q_co * v * FoRT) "relative frequency of E2 states that are occupied by Ca2+ and occluded";
  Real do_1n = na_ex / k_1n_o "relative frequency of E2 states where only the first Na+ site is occupied by Na+";
  Real do_2n = do_1n * na_ex / k_2n_o "relative frequency of E2 states where exactly the first two Na+ sites are occupied by Na+";
  Real do_3n = do_2n * na_ex / k_3n_o "relative frequency of E2 states where exactly three Na+ sites are occupied by Na+";
  Real do = 1 + do_c + do_cv + do_1n + do_2n + do_3n "common denominator summing relative frequencies for all E2 substates";
  Fraction f_c_i = di_cv / di "fraction of E1 states with occluded Ca ions";
  Fraction f1_2n_i = (di_2n + di_3n) / di "fraction of E1 states whose first two Na+ sites are occupied by Na+";
  // Fraction f_3n_i = di_3n / di; // NOTE: unused?
  Fraction f1_3n_i = michaelisMenten(na_in, k_3n_i) "fraction of E1 states whose first two Na+ sites are occupied by Na+";
  Fraction f_c_o = do_cv / do "fraction of E2 states with occluded Ca ions";
  Fraction f1_2n_o = (do_2n + do_3n) / do "fraction of E2 states whose first two Na+ sites are occupied by Na+";
  // Fraction f_3n_o = do_3n / do; // NOTE: unused?
  Fraction f1_3n_o = michaelisMenten(na_ex, k_3n_o) "fraction of E2 states whose first two Na+ sites are occupied by Na+";
  Real k_12 = f_c_i "rate constant for transition from E1 to E2";
  Real k_21 = f_c_o "rate constant for transition from E2 to E1";
  Real k_23 = f1_2n_o / na_v "rate constant for transition from E2 to E3";
  Real k_32 = na_v "rate constant for transition from E3 to E2";
  Real k_34 = f1_3n_o "rate constant for transition from E3 to E4";
  Real k_43 = f1_3n_i "rate constant for transition from E4 to E3";
  Real k_41 = 1 / na_v "rate constant for transition from E4 to E1";
  Real k_14 = f1_2n_i * na_v "rate constant for transition from E1 to E4";
  Real x1 = k_34 * k_41 * (k_23 + k_21) + k_21 * k_32 * (k_43 + k_41) "relative frequency of E1 states";
  Real x2 = k_43 * k_32 * (k_14 + k_12) + k_41 * k_12 * (k_34 + k_32) "relative frequency of E2 states";
  Real x3 = k_43 * k_14 * (k_23 + k_21) + k_12 * k_23 * (k_43 + k_41) "relative frequency of E3 states";
  Real x4 = k_34 * k_23 * (k_14 + k_12) + k_21 * k_14 * (k_34 + k_32) "relative frequancy of E4 states";
  Real d = x1 + x2 + x3 + x4 "common denominator to turn relative frequencies into actual ratios between 0 and 1";
  Fraction e1 = x1 / d "ratio of exchanger molecules in state e1";
  Fraction e2 = x2 / d "ratio of exchanger molecules in state e2";
  Fraction e3 = x3 / d "ratio of exchanger molecules in state e3";
  Fraction e4 = x4 / d "ratio of exchanger molecules in state e4";
protected
  parameter Real FoRT = Modelica.Constants.F / Modelica.Constants.R / temp "helper variable to simplify equations";
  Real na_v = exp(q_n * v / 2 * FoRT) "voltage term due to Na+ occlusion";
equation
  i = k_NaCa * (k_21 * e2 - k_12 * e1);
  annotation(
    Documentation(info = "<html>
  <p>This is the E4 model developed by Matsuoka et al. (Matsuoka 1992).
  It represents the sodium-calcium exchanger as a system with four states.
  Each of the states is itself actually a set of states between which an
  equilibrium is assumed to be achieved instantly.</p>
  <ul>
    <li>E1
      <ul>
        <li>A: open to intracellular side and occupied by 3 Na+</li>
        <li>B: open to intracellular side and unoccupied</li>
        <li>C: open to intracellular side and occupied by 1 Ca2+</li>
        <li>D: open to intracellular side and occuped by 1 Ca2+ and 1 Na+</li>
        <li>E: closed and occupied by 1 Ca2+ on intracellular side</li>
      </ul>
    </li>
    <li>
      E2
      <ul>
        <li>A: closed and occupied by 1 Ca2+ on extracellular side</li>
        <li>B: open to extracellular side and occupied by 1 Ca2+</li>
        <li>C: open to extracellular side and unoccupied</li>
        <li>D: open to extracellular side and occupied by 3 Na+</li>
      </ul>
    </li>
    <li>
      E3: closed and occupied by 3 Na+, 1 Na+ unoccluded on extracellular side
    </li>
    <li>
      E4: closed and occupied by 3 Na+, 1 Na+ unoccluded on intracellular side
    </li>
  </ul>
  <p>Between these states, a cyclic kinetic reaction exists as follows:</p>
  <p>E1E ⇋ E2A ↔ E2D ⇋ E3 ⇋ E4 ⇋ E1A ↔ E1E ⇋ ...</p>
  <p>Here, a ⇋ denotes a kinetic transition between two states and ↔ denotes
  one or multiple instantaneous transitions within a state.</p>
  <p>To obtain the overall cycle rate and thus current, the transition between
  E1 and E2 is examined although this is not an electrogenic step in the
  model.
  This is fine, because the cycle rate should remain the same regardless of
  which transition is examined.</p>
</html>"));
end SodiumCalciumExchanger;
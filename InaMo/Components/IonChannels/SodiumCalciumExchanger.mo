within InaMo.Components.IonChannels;
model SodiumCalciumExchanger
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  IonConcentration c_sub;
  parameter Real V_sub = 1;
  // TODO replace MobileIon with more simple construct
  // TODO we only need c_sub and calcium.c_ex, not calcium.c_in
  input MobileIon sodium;
  input MobileIon calcium;
  TemperatureInput T;
  parameter SI.Concentration K_c_i = 0.0207 "dissociation constant for channel with Ca++ bound on inside";
  parameter SI.Concentration K_cn_i = 26.44 "dissociation constant for channel with Ca++ and one Na+ bound on inside";
  parameter SI.Concentration K_1n_i = 395.3 "dissociation constant for channel with one Na+ bound on inside";
  parameter SI.Concentration K_2n_i = 2.289 "dissociation constant for channel with two Na+ bound on inside";
  parameter SI.Concentration K_3n_i = 26.44 "dissociation constant for channel with three Na+ bound on inside";
  parameter SI.Concentration K_c_o = 3.663 "dissociation constant for channel with Ca++ bound on outside";
  parameter SI.Concentration K_1n_o = 1628 "dissociation constant for channel with one Na+ bound on outside";
  parameter SI.Concentration K_2n_o = 561.4 "dissociation constant for channel with two Na+ bound on outside";
  parameter SI.Concentration K_3n_o = 4.663 "dissociation constant for channel with three Na+ bound on outside";
  parameter Real Q_ci = 0.1369 "fractional charge movement during intracellular Ca++ occlusion reaction";
  parameter Real Q_co = 0 "fractional charge movement during extracellular Ca++ occlusion reaction";
  parameter Real Q_n = 0.4315 "fractional charge movement during Na+ occlusion reactions";
  parameter SI.Current k_NaCa = 5.92e-9 "scaling factor for Na+/Ca++ exchanger current";
  Real di_c = c_sub.c / K_c_i "relative frequency of E1 states that are occupied by Ca2+ and not occluded";
  Real di_cv = di_c * exp(-Q_ci * v * FoRT) "relative frequency of E1 states that are occupied by Ca2+ and occluded";
  Real di_cn = di_c * sodium.c_in / K_cn_i "relative frequency of E1 states whose first two binding sites are occupied by Ca2+ and whose last binding site is occupied by Na+";
  Real di_1n = sodium.c_in / K_1n_i "relative frequency of E1 states where only the first Na+ site is occupied by Na+";
  Real di_2n = di_1n * sodium.c_in / K_2n_i "relative frequency of E1 states where exactly the first two Na+ sites are occupied by Na+";
  Real di_3n = di_2n * sodium.c_in / K_3n_i "relative frequency of E1 states where exactly three Na+ sites are occupied by Na+";
  Real di = 1 + di_c + di_cv + di_cn + di_1n + di_2n + di_3n "common denominator summing relative frequencies for all E1 substates";
  Real do_c = calcium.c_ex / K_c_o "relative frequency of E2 states that are occupied by Ca2+ and not occluded"; // TODO: is description correct?
  Real do_cv = do_c * exp(Q_co * v * FoRT) "relative frequency of E2 states that are occupied by Ca2+ and occluded";
  Real do_1n = sodium.c_ex / K_1n_o "relative frequency of E2 states where only the first Na+ site is occupied by Na+";
  Real do_2n = do_1n * sodium.c_ex / K_2n_o "relative frequency of E2 states where exactly the first two Na+ sites are occupied by Na+";
  Real do_3n = do_2n * sodium.c_ex / K_3n_o "relative frequency of E2 states where exactly three Na+ sites are occupied by Na+";
  Real do = 1 + do_c + do_cv + do_1n + do_2n + do_3n "common denominator summing relative frequencies for all E2 substates";
  Real F_c_i = di_cv / di "fraction of E1 states with occluded Ca ions";
  Real F1_2n_i = (di_2n + di_3n) / di "fraction of E1 states whose first two Na+ sites are occupied by Na+";
  // Real F_3n_i = di_3n / di; // TODO: unused?
  Real F1_3n_i = sodium.c_in / K_3n_i / (1 + sodium.c_in / K_3n_i) "fraction of E1 states whose first two Na+ sites are occupied by Na+";
  Real F_c_o = do_cv / do "fraction of E2 states with occluded Ca ions";
  Real F1_2n_o = (do_2n + do_3n) / do "fraction of E2 states whose first two Na+ sites are occupied by Na+";
  // Real F_3n_o = do_3n / do; // TODO: unused?
  Real F1_3n_o = sodium.c_ex / K_3n_o / (1 + sodium.c_ex / K_3n_o) "fraction of E2 states whose first two Na+ sites are occupied by Na+";
  Real k_12 = F_c_i "rate constant for transition from E1 to E2";
  Real k_21 = F_c_o "rate constant for transition from E2 to E1";
  Real k_23 = F1_2n_o / na_v "rate constant for transition from E2 to E3";
  Real k_32 = na_v "rate constant for transition from E3 to E2";
  Real k_34 = F1_3n_o "rate constant for transition from E3 to E4";
  Real k_43 = F1_3n_i "rate constant for transition from E4 to E3";
  Real k_41 = 1 / na_v "rate constant for transition from E4 to E1";
  Real k_14 = F1_2n_i * na_v "rate constant for transition from E1 to E4";
  Real x1 = k_34 * k_41 * (k_23 + k_21) + k_21 * k_32 * (k_43 + k_41) "relative frequency of E1 states";
  Real x2 = k_43 * k_32 * (k_14 + k_12) + k_41 * k_12 * (k_34 + k_32) "relative frequency of E2 states";
  Real x3 = k_43 * k_14 * (k_23 + k_21) + k_12 * k_23 * (k_43 + k_41) "relative frequency of E3 states";
  Real x4 = k_34 * k_23 * (k_14 + k_12) + k_21 * k_14 * (k_34 + k_32) "relative frequancy of E4 states";
  Real d = x1 + x2 + x3 + x4 "common denominator to turn relative frequencies into actual ratios between 0 and 1";
  Real E1 = x1 / d "ratio of exchanger molecules in state E1";
  Real E2 = x2 / d "ratio of exchanger molecules in state E2";
  Real E3 = x3 / d "ratio of exchanger molecules in state E3";
  Real E4 = x4 / d "ratio of exchanger molecules in state E4";
protected
  Real FoRT = Modelica.Constants.F / Modelica.Constants.R / T;
  Real na_v = exp(Q_n * v / 2 * FoRT);
equation
  i = k_NaCa * (k_21 * E2 + k_12 * E1);
  c_sub.rate = 2 * i / 2 / Modelica.Constants.F / V_sub;
end SodiumCalciumExchanger;

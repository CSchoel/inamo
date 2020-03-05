within InaMo.Components.IonChannels;
model SodiumCalciumExchanger
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  input MobileIon sodium;
  input MobileIon calcium;
  TemperatureInput T;
  parameter Real K_c_i = 1 "dissociation constant for channel with Ca++ bound on inside";
  parameter Real K_cn_i = 1 "dissociation constant for channel with Ca++ and one Na+ bound on inside";
  parameter Real K_1n_i = 1 "dissociation constant for channel with one Na+ bound on inside";
  parameter Real K_2n_i = 1 "dissociation constant for channel with two Na+ bound on inside";
  parameter Real K_3n_i = 1 "dissociation constant for channel with three Na+ bound on inside";
  parameter Real K_c_o = 1 "dissociation constant for channel with Ca++ bound on outside";
  parameter Real K_1n_o = 1 "dissociation constant for channel with one Na+ bound on outside";
  parameter Real k_2n_o = 1 "dissociation constant for channel with two Na+ bound on outside";
  parameter Real k_3n_o = 1 "dissociation constant for channel with three Na+ bound on outside";
  parameter Real Q_ci = 1 "fractional charge movement during intracellular Ca++ occlusion reaction";
  parameter Real Q_co = 1 "fractional charge movement during extracellular Ca++ occlusion reaction";
  parameter Real Q_n = 1 "fractional charge movement during Na+ occlusion reactions";
  parameter Real k_x = 1; // value must be cube root of k_naca in inada
  Real di_c = calcium.c_in / K_c_i;
  Real di_cv = di_c * exp(-Q_ci * v * FoRT);
  Real di_cn = d_c * sodium.c_in / K_cn_i;
  Real di_1n = sodium.c_in / K_1n_i;
  Real di_2n = di_1n * sodium.c_in / K_2n_i;
  Real di_3n = di_2n * sodium.c_in / K_3n_i;
  Real di = 1 + di_c + di_cv + di_cn + di_1n + di_2n + di_3n;
  Real do_c = calcium.c_ex / K_c_o;
  Real do_cv = do_c * exp(Q_co * v * FoRT);
  Real do_1n = sodium.C_ex / K_1n_o;
  Real do_2n = sodium.C_ex / K_2n_o;
  Real do_3n = sodium.C_ex / K_3n_o;
  Real do = 1 + do_c + do_cv + do_1n + do_2n + do_3n;
  Real F_c_i = di_cv / di;
  Real F_2n_i = (di_2n + di_3n) / di "fraction of E1 states whose first two Na+ sites are occupied by Na+";
  Real F_3n_i = di_3n / di; // TODO: unused?
  Real F1_3n_i = sodium.c_in / K_3n_i / (1 + sodium.c_in / K_3n_i) "fraction of E";
  Real F_c_o = do_cv / do;
  Real F_2n_o = (do_2n + do_3n) / do "fraction of E2 states whose first two Na+ sites are occupied by Na+";
  Real F_3n_o = do_3n / do; // TODO: unused?
  Real F1_3n_o = sodium.c_ex / K_3n_o / (1 + sodium.c_ex / K_3n_o);
  Real k_12 = k_x * F_c_i "rate constant for transition from E1 to E2";
  Real k_21 = k_x * F_c_o "rate constant for transition from E2 to E1";
  Real k_23 = k_x * F_2n_o / na_v "rate constant for transition from E2 to E3";
  Real k_32 = k_x * na_v "rate constant for transition from E3 to E2";
  Real k_34 = k_x * F1_3n_o "rate constant for transition from E3 to E4";
  Real k_43 = k_x * F1_3n_i "rate constant for transition from E4 to E3";
  Real k_41 = k_x / na_v "rate constant for transition from E4 to E1";
  Real k_14 = k_x * F_2n_i * na_v "rate constant for transition from E1 to E4";
  Real x1 = k_34 * k_41 * (k_23 + k_21) + k_21 * k_32 * (k_43 + k_41);
  Real x2 = k_43 * k_32 * (k_14 + k_12) + k_41 * k_12 * (k_34 + k_32);
  Real x3 = k_43 * k_14 * (k_23 + k_21) + k_12 * k_23 * (k_43 + k_41);
  Real x4 = k_34 * k_23 * (k_14 + k_12) + k_21 * k_14 * (k_34 + k_32);
  Real d = x1 + x2 + x3 + x4;
  Real E1 = x1 / d "ratio of exchanger molecules in state E1";
  Real E2 = x2 / d "ratio of exchanger molecules in state E2";
  Real E3 = x3 / d "ratio of exchanger molecules in state E3";
  Real E4 = x4 / d "ratio of exchanger molecules in state E4";
protected
  Real FoRT = Modelica.Constants.F / Modelica.Constants.R / T;
  Real na_v = exp(Q_n * v / 2 * FoRT);
equation
  i = k_21 * E2 + k_12 * E1;
end SodiumCalciumExchanger;

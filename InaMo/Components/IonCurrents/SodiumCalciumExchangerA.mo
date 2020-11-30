within InaMo.Components.IonCurrents;
model SodiumCalciumExchangerA "I_NaCa for atrial cell model (Lindblad 1996)"
  extends OnePortVertical;
  extends TransmembraneNaFlow(n_na=3);
  extends TransmembraneCaFlow(n_ca=-2);
  extends InaMo.Icons.IonChannel;
  extends InaMo.Icons.SodiumCalciumExchanger;
  extends InaMo.Icons.Current(current_name="I_NaCa");
  extends Modelica.Icons.UnderConstruction;
  inner SI.Current i_ion = i;
  outer parameter SI.Volume v_ca, v_cyto; // FIXME not sure if v_cyto should be used here
  outer parameter SI.Concentration na_ex, ca_ex;
  outer parameter SI.Temperature temp;
  // TODO better description and possibly names of variables and parameters
  parameter SI.Current i_max "scaling factor";
  parameter Real d_NaCa "denominator constant";
  parameter Real n_NaCa "coupling ratio of Na+ to Ca2+ ions";
  parameter Real z_NaCa "???";
  parameter Real gamma "TODO";
  SI.Voltage f_over_rt = Modelica.Constants.F / (Modelica.Constants.R * temp);
  Real phi_f = exp(gamma * exp_v) "forward term in voltage dependence";
  Real phi_r = exp(- (1 - gamma) * exp_v) "reverse term in voltage dependence";
  Real act = (na_in_n * ca_ex * phi_f - na_ex_n * ca.amount / v_ca * phi_r)
           / (1 + d_NaCa * (na_ex_n * ca.amount / v_ca + na_in_n * ca_ex)) "activation rate of pump";
protected
  Real exp_v = v * (n_NaCa - 2) * z_NaCa * f_over_rt;
  Real na_in_n = (na.amount / v_cyto) ^ n_NaCa;
  Real na_ex_n = na_ex ^ n_NaCa;
equation
  i = i_max * act;
end SodiumCalciumExchangerA;

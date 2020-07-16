within InaMo.Components.IonChannels;
model SodiumCalciumExchangerA "I_NaCa for atrial cell model (Lindblad 1996)"
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  extends NaFlux(n_na=3, vol_na=v_cyto);
  extends CaFlux(n_ca=-2, vol_ca=v_ca);
  outer parameter SI.Volume v_cyto, v_ca;
  outer parameter SI.Concentration na_out, ca_out;
  outer parameter SI.Temperature temp;
  // TODO better description and possibly names of variables and parameters
  parameter SI.Current i_max "scaling factor";
  parameter Real d_NaCa "denominator constant";
  parameter Real n_NaCa "coupling ratio of Na+ to Ca2+ ions";
  parameter Real z_NaCa "???";
  SI.Voltage f_over_rt = Modelica.Constants.F / (Modelica.Constants.R * temp);
  Real phi_f = exp(gamma * exp_v) "forward term in voltage dependence";
  Real phi_r = exp(- (1 - gamma) * exp_v) "reverse term in voltage dependence";
  Real act = (na_in_n * ca_out * phi_f - na_out_n * ca.c * phi_r)
           / (1 + d_NaCa * (na_out_n * ca_in + na_in_n * ca_out)) "activation rate of pump";
protected
  Real exp_v = v * (n_NaCa - 2) * z_NaCa * f_over_rt;
  Real na_in_n = na.c ^ n_NaCa;
  Real na_out_n = na_out ^ n_NaCa;
equation
  i = i_max * act;
end SodiumCalciumExchangerA;

model CaDiffusionSimple
  parameter Real sub_cyto_tau(quantity = "Time", unit = "s") = 4e-05 "time constant of diffusion";
  Real ca_sub_substance_amount(quantity = "AmountOfSubstance", unit = "mol", min = 0.0); // nominal = 1e-21
  Real ca_cyto_substance_amount(quantity = "AmountOfSubstance", unit = "mol", min = 0.0); // nominal = 1e-21
  Real ca_sub_con(quantity = "Concentration", unit = "mol/m3") = ca_sub_substance_amount / v_sub;
  Real ca_cyto_con(quantity = "Concentration", unit = "mol/m3") = ca_cyto_substance_amount / v_cyto;
  parameter Real ca_sub_c_start(quantity = "Concentration", unit = "mol/m3") = 6.397e-05 "initial value of concentration";
  parameter Real ca_cyto_c_start(quantity = "Concentration", unit = "mol/m3") = 0.0001206 "initial value of concentration";
  parameter Real v_sub(quantity = "Volume", unit = "m3") = 4.398227e-17;
  parameter Real v_cyto(quantity = "Volume", unit = "m3") = 1.9792021e-15;
  parameter Real sub_cyto_vol_trans(quantity = "Volume", unit = "m3") = min(v_sub, v_cyto) "volume of substance that is transferred between compartments over one second";
initial equation
  ca_sub_substance_amount = ca_sub_c_start * v_sub;
  ca_cyto_substance_amount = ca_cyto_c_start * v_cyto;
equation
  der(ca_sub_substance_amount) = -(ca_sub_substance_amount / v_sub - ca_cyto_substance_amount / v_cyto) * sub_cyto_vol_trans / sub_cyto_tau;
  der(ca_cyto_substance_amount) = (ca_sub_substance_amount / v_sub - ca_cyto_substance_amount / v_cyto) * sub_cyto_vol_trans / sub_cyto_tau;
end CaDiffusionSimple;

within InaMo.Components.Functions;
function p_from_g "calculate permeability from conductance"
  input SI.Conductance g;
  input SI.Concentration ion_ex;
  input Integer ion_z;
  input SI.Temperature temp;
  output PermeabilityFM p;
algorithm
  p := g / ion_ex * Modelica.Constants.R * temp / (Modelica.Constants.F * ion_z)^2;
end p_from_g;

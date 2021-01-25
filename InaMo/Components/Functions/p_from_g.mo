within InaMo.Components.Functions;
function p_from_g "calculate membrane permeability for ion from membrane conductance"
  extends Modelica.Icons.Function;
  input SI.Conductance g "membrane conductance for given ion";
  input SI.Concentration ion_ex "extracellular ion concentration";
  input Integer ion_z "valence of ion";
  input SI.Temperature temp "cell medium temperature";
  output PermeabilityFM p "membrane permeability for given ion";
protected
  SI.Area unit_area = 1 "unit area of 1 m², used to get correct units";
algorithm
  p := g / ion_ex * Modelica.Constants.R * temp / (Modelica.Constants.F * ion_z)^2 / unit_area;
end p_from_g;

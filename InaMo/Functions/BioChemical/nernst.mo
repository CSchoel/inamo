within InaMo.Functions.Biological;
function nernst "Nernst equation to find the equlibrium potential for a single ion"
  extends Modelica.Icons.Function;
  import Modelica.Constants.*;
  input SI.Concentration ion_in "intracellular ion concentration";
  input SI.Concentration ion_ex "extracellular ion concentration";
  input Integer ion_z "valence of ion";
  input SI.Temperature temp "cell medium temperature";
  output SI.Voltage v_eq "equlibirium potential";
algorithm
  v_eq := R * temp / ion_z / F  * log(ion_ex / ion_in);
end nernst;

within InaMo.Components.Functions;
function nernst "Nernst equation for a single ion"
  extends Modelica.Icons.Function;
  import Modelica.Constants.*;
  input SI.Concentration ion_in;
  input SI.Concentration ion_ex;
  input Integer ion_z;
  input SI.Temperature temp;
  output SI.Voltage v_eq;
algorithm
  v_eq := R * temp / ion_z / F  * log(ion_ex / ion_in);
end nernst;

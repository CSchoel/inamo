within InaMo.Components.Functions;
function nernst "Nernst equation for a single ion"
  import Modelica.Constants.*;
  input SI.Concentration ion_in;
  input SI.Concentration ion_ex;
  input Integer ion_z;
  input SI.Temperature T;
  output SI.Voltage v_eq;
algorithm
  v_eq := R * T / ion_z / F  * log(ion_ex / ion_in);
end nernst;

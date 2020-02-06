within InaMo.Components.Functions;
function nernst "Nernst equation for a single ion"
  import InaMo.Components.Connectors.MobileIon;
  import Modelica.Constants.*;
  input MobileIon ion;
  input SI.Temperature T;
  output SI.Voltage v_eq;
algorithm
  v_eq := R * T / ion.z / F  * log(ion.c_ex / ion.c_in);
end nernst;

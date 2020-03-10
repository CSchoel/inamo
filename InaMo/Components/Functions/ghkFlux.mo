within InaMo.Components.Functions;
function ghkFlux "ghk flux equation for a single ion"
  import InaMo.Components.Connectors.MobileIon;
  input SI.Voltage v;
  input SI.Temperature T;
  input MobileIon ion;
  output SI.CurrentDensity i;
protected
  SI.Conductance g_max;
  SI.Voltage v_eq;
  Real FoRT(unit="C/J") = Modelica.Constants.F / (Modelica.Constants.R * T);
algorithm
  g_max := ion.p * ion.c_ex * FoRT * Modelica.Constants.F * ion.z ^ 2;
  v_eq := nernst(ion, T);
  // FIXME do we have a bug here that causes the bump in lindblad1997_2B?
  if v == 0 then // using L'Hôpital to find limit for V->0
    i := g_max / FoRT / ion.z * (exp(-v_eq * FoRT * ion.z) - 1);
  else
    i := g_max * v * (exp((v - v_eq) * FoRT * ion.z) - 1) / (exp(v * FoRT * ion.z) - 1);
  end if;
annotation(
  Documentation(info="
    <html>
      <p>This model uses an alternative formalism to determine the ionic
      current through an ion channel that is based on the
      Goldman-Hodgkin-Katz (GHK) flux equation (not to be confused with the
      GHK voltage equation).</p>
      <p>You can reconstruct the formula starting from equation (17) of
      Goldman (1943) and then factoring out Lambda+ and substituting
      Lambda-/Lambda+ = exp(beta V0).</p>
      <p>Since this model assumes that we will only have one cation,
      the sum of anions in Lambda+ is empty and we are left with
      Lambda+ = P_x * [x]_o * F²/(RT) where P is the permeability of ion x
      and [x]_o is the extracellular concentration of x.</p>
      <p>For a much more detailed explanation of the GHK flux equation see
      Alvarez and Latorre 2017.</p>
    </html>
  ")
);
end ghkFlux;

within InaMo.Components.IonChannels;
function ghkFlux "ghk flux equation for a single ion"
  input SI.Voltage v;
  input SI.Temperature T;
  input MobileIon ion;
  output SI.Current i;
protected
  SI.Conductance g_max;
  SI.Voltage v_eq;
  Real FoRT(unit="C/J") = Modelica.Constants.F / (Modelica.Constants.R * T);
algorithm
  g_max := ion.p * ion.c_ex * FoRT * Modelica.Constants.F * ion.z ^ 2;
  v_eq := 1/FoRT / ion.z * log(ion.c_ex / ion.c_in) "using Nernst";
  if v == 0 then // using L'Hôpital to find limit for V->0
    // TODO units are not matching here => add constant to fix this
    i := g_max / FoRT * (exp(-v_eq * FoRT * ion.z) - 1);
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

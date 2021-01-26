within InaMo.Components.Functions;
function ghkFlux "ghk flux equation for a single ion"
  extends Modelica.Icons.Function;
  input SI.Voltage v "membrane potential";
  input SI.Temperature temp "cell medium temperature";
  input SI.Concentration ion_in "intracellular ion concentration";
  input SI.Concentration ion_ex "extracellular ion concentration";
  input PermeabilityFM ion_p "permeability of cell membrane to Na+ cations";
  input Integer ion_z "ion valence";
  output SI.CurrentDensity i "current density resulting from ion flux through membrane";
protected
  SI.Conductance g_max;
  SI.Voltage v_eq;
  Real FoRT(unit="1/V") = Modelica.Constants.F / (Modelica.Constants.R * temp);
algorithm
  g_max := ion_p * ion_ex * FoRT * Modelica.Constants.F * ion_z ^ 2;
  v_eq := nernst(ion_in, ion_ex, ion_z, temp);
  if abs(v) < 1e-6 then // using L'Hôpital to find limit for V->0
    i := g_max / FoRT / ion_z * (exp(-v_eq * FoRT * ion_z) - 1);
  else
    i := g_max * v * (exp((v - v_eq) * FoRT * ion_z) - 1) / (exp(v * FoRT * ion_z) - 1);
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

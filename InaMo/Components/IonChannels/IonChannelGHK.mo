within InaMo.Components.IonChannels;
partial model IonChannelGHK "ion channel with Goldman-Hodgkin-Katz (GHK) behavior"
  extends GatedIonChannel;
  parameter SI.Permeability P "Na+ permeability for sodium current";
  input SI.Concentration C_ex "extracellular ion concentration";
  TemperatureInput T "membrane temperature";
  SI.Conductance G_max "maximum conductance achieved for large potentials";
protected
  Real FoRT(unit="C/J") = Modelica.Constants.F / (Modelica.Constants.R * T);
equation
  G_max = P * C_ex * Modelica.Constants.F * FoRT;
  i_open = G_max * v * (exp((v - V_eq) * FoRT) - 1) / (exp(v * FoRT) - 1);
  annotation(
    Documentation(info="
      <html>
        <p>This model uses an alternative formalism to determine the ionic
        current through an ion channel that is based on the
        Goldman-Hodgkin-Katz equation.</p>
        <p>You can reconstruct the formula starting from equation (17) of
        Goldman (1943) and then factoring out Lambda+ and substituting
        Lambda-/Lambda+ = exp(beta V0).</p>
        <p>Then we find that Lambda+ = P_x * [x]_o * F²/(RT) where P is the
        permeability of ion x and [x]_o is the extracellular concentration
        of x.</p>
        <!-- NOTE: not entirely sure why we do not need [x]_i for Lambda+ -->
      </html>
    ")
);
end IonChannelGHK;

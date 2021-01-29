within InaMo.Currents.Interfaces;
partial model IonChannelGHK "ion channel with Goldman-Hodgkin-Katz (GHK) behavior"
  extends GatedIonChannel;
  SI.Concentration ion_in "intracellular concentration of ion";
  parameter SI.Concentration ion_ex "extracellular concentration of ion";
  parameter PermeabilityFM ion_p "permeability of ion";
  parameter Integer ion_z = 1 "valence of ion";
  outer parameter SI.Temperature temp "membrane temperature";
equation
  i_open = ghkFlux(v, temp, ion_in, ion_ex, ion_p, ion_z) * unitArea "multiply with unit area to preserve correct units";
annotation(Documentation(info="<html>
  <p>This base class is an alternative to the usual formulation using
  InaMo.Currents.Interfaces.IonChannelElectric.
  It uses the Goldman-Hodgkin-Katz (GHK) flux equation to define the
  current based on ion concnetrations and membrane permeability.</p>
</html>"));
end IonChannelGHK;

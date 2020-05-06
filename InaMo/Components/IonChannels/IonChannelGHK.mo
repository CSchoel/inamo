within InaMo.Components.IonChannels;
partial model IonChannelGHK "ion channel with Goldman-Hodgkin-Katz (GHK) behavior"
  extends GatedIonChannel;
  parameter SI.Concentration ion_in "intracellular concentration of ion";
  parameter SI.Concentration ion_ex "extracellular concentration of ion";
  parameter PermeabilityFM ion_p "permeability of ion";
  parameter Integer ion_z = 1 "valence of ion";
  outer parameter SI.Temperature temp "membrane temperature";
equation
  i_open = ghkFlux(v, temp, ion_in, ion_ex, ion_p, ion_z) * unitArea "multiply with unit area to preserve correct units";
end IonChannelGHK;

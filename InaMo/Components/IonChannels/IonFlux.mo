within InaMo.Components.IonChannels;
model IonFlux
  IonConcentration ion "ion whose concentration changes";
  outer SI.Current i_ion "current responsible for moving ions";
  parameter SI.Volume vol "volume of compartment";
  parameter Real n "soichiometric ratio of ion transport";
equation
  ion.rate = n * (i / vol * Modelica.Constants.F);
end IonFlux;

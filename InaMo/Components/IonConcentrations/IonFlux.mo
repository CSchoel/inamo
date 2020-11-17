within InaMo.Components.IonConcentrations;
model IonFlux
  replaceable connector IonSite = CalciumSite;
  IonSite ion "ion whose concentration changes";
  outer SI.Current i_ion "current responsible for moving ions";
  parameter Real n "stoichiometric ratio of ion transport";
  parameter Integer z "valence of ion";
equation
  ion.rate = n * i_ion / (z * Modelica.Constants.F);
end IonFlux;

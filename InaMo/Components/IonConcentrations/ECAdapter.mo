within InaMo.Components.IonConcentrations;
model ECAdapter "adapter between electrical current and chemical substance flow rate"
  SI.Current i "current due to substance transport";
  SI.MolarFlowRate rate "flow rate of substance transport";
  parameter Real(unit="1") n "stoichiometric ratio of ion transport";
  parameter Integer z "valence of ion";
equation
  rate = n * i / (z * Modelica.Constants.F);
end ECAdapter;

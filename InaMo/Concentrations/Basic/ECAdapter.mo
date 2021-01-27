within InaMo.Concentrations.Basic;
model ECAdapter "adapter between electrical current and chemical substance flow rate"
  extends InaMo.Icons.Adapter;
  SI.Current i "current due to substance transport";
  SI.MolarFlowRate rate "flow rate of substance transport";
  parameter Real n(unit="1") "stoichiometric ratio of ion transport";
  parameter Integer z "valence of ion";
equation
  rate = n * i / (z * Modelica.Constants.F);
end ECAdapter;

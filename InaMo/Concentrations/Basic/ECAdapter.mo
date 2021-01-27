within InaMo.Concentrations.Basic;
model ECAdapter "adapter between electrical current and chemical substance flow rate"
  extends InaMo.Icons.Adapter;
  SI.Current i "current due to substance transport";
  SI.MolarFlowRate rate "flow rate of substance transport";
  parameter Real n(unit="1") "stoichiometric ratio of ion transport";
  parameter Integer z "valence of ion";
equation
  rate = n * i / (z * Modelica.Constants.F);
annotation(Documentation(info="<html>
  <p>This model can be used as component in models that need to convert
  between chemical ion flow rates and the current introduced through this flow.
  If a defining equation for <code>i</code> is provided, <code>rate</code>
  will contain the corresponding ion flow rate and vice versa.</p>
</html>"));
end ECAdapter;

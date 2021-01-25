within InaMo.Components.Functions;
function reactionRateQ10 "adjusted reaction rate based on temperature change using the Q10 temperature coefficient"
  extends Modelica.Icons.Function;
  import Modelica.SIunits.Conversions.from_degC;
  input SI.Temperature temp_act "actual temperature";
  input SI.Temperature temp_ref = from_degC(37) "reference temperature";
  input Real rate_ref = 1 "reaction rate at reference temperature";
  input Real q10 = 3 "factor of change in reaction rate for temperature difference of 10 degrees";
  output Real rate "reaction rate at actual temperature";
algorithm
  rate := rate_ref * q10 ^ ((temp_act - temp_ref) / 10);
annotation(Documentation(info="<html>
  <p>This function can be used to adjust reaction rates to different
  temperatures.
  The Inada model assumes 37 °C for most reactions.
  If this temperature is changed, equations for gating variables and other
  equations based on chemical reactions have to be adjusted.
  This equation could be used to automate this, but we currently do not do
  this as it would be cumbersome and error-prone to identify all equations
  that need to change.</p>
</html>"));
end reactionRateQ10;

within InaMo.Components.Functions.Fitting;
function reactionRateFit
  extends Modelica.Icons.Function;
  import Modelica.SIunits.Conversions.to_degC;
  input SI.Temperature temp_act "actual temperature";
  input SI.Temperature temp_ref = to_degC(37) "reference temperature (fitting parameter)";
  input Real q10 = 3 "factor of change in reaction rate for temperature difference of 10 degree celsius (fitting parameter)";
  output Real factor "factor of change in reaction rate due to temperature";
algorithm
  factor := q10 ^ ((to_degC(temp_act) - to_degC(temp_ref)) / 10);
end reactionRateFit;

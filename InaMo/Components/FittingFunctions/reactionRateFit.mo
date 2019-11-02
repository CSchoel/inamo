within InaMo.Components.FittingFunctions;
function reactionRateFit
  import Modelica.SIunits.Conversions.to_degC;
  input SI.Temperature T_act "actual temperature";
  input SI.Temperature T_ref "reference temperature (fitting parameter)";
  input Real q10 "factor of change in reaction rate for temperature difference of 10 degree celsius (fitting parameter)";
  output Real factor "factor of change in reaction rate due to temperature";
algorithm
  factor := q10 ^ ((to_degC(T_act) - to_degC(T_ref)) / 10);
end reactionRateFit;

within InaMo.Components.Functions.Fitting;
function pseudoABSteady "uses pseudo alpha and beta functions to calculate HH-style steady state"
  extends Modelica.Icons.Function;
  replaceable function falpha = expFit "first fitting function (not to be confused with opening ratio in HH)";
  replaceable function fbeta = expFit "second fitting function (not to be confused with closing ratio in HH)";
  input Real x "input value";
  output Real y "result of applying the HH-style equation steady = alpha/(alpha + beta)";
algorithm
  y := falpha(x) / (falpha(x) + fbeta(x));
annotation(Documentation(info="<html>
  <p>This function is required in Hodgkin-Huxley-style ion channels that use a
  mix of styles where the actual gating equations define the time constant
  and steady state, but the steady state is again defined via two equations
  for an alpha and a beta variable.</p>
  <p>It is important not to confuse this use of alpha and beta with the alpha
  and beta variables that define the opening and closing ratio in the original
  HH model.
  While they have the same structure, the alpha and beta in this function are
  meaningless on their own, because they only influence the steady state and
  not the time constant.
  The use of this function is only to construct a fitting function that can
  fit typical shapes of steady state functions.</p>
</html>"));
end pseudoABSteady;

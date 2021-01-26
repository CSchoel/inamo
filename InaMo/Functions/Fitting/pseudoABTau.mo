within InaMo.Components.Functions.Fitting;
function pseudoABTau "uses pseudo alpha and beta functions to calculate HH-style time constant"
  extends Modelica.Icons.Function;
  replaceable function falpha = expFit "first fitting function (not to be confused with opening ratio in HH)";
  replaceable function fbeta = expFit "second fitting function (not to be confused with closing ratio in HH)";
  input Real x "input value";
  input Real off = 0 "offset added to result to increase minimum (fitting parameter)";
  output Real y "result of applying the HH-style equation tau = 1/(alpha + beta)";
algorithm
  y := 1 / (falpha(x) + fbeta(x)) + off;
annotation(Documentation(info="<html>
  <p>This function is required in Hodgkin-Huxley-style ion channels that use a
  mix of styles where the actual gating equations define the time constant
  and steady state, but the time constant is again defined via two equations
  for an alpha and a beta variable.</p>
  <p>It is important not to confuse this use of alpha and beta with the alpha
  and beta variables that define the opening and closing ratio in the original
  HH model.
  While they have the same structure, the alpha and beta in this function are
  meaningless on their own, because they only influence the time constant and
  not the steady state.
  The use of this function is only to construct a fitting function that can
  fit typical shapes of time constant functions.</p>
</html>"));
end pseudoABTau;

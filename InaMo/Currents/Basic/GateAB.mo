within InaMo.Components.IonCurrents;
model GateAB "gating molecule with two conformations/positions X and Y governed by two functions alpha and beta"
  extends InaMo.Icons.Gate;
  import InaMo.Functions.Fitting.*;
  replaceable function falpha = goldman(x0=0, sx=1, sy=1) "rate of transfer from conformation Y to X";
  replaceable function fbeta = expFit(x0=0, sx=1, sy=1) "rate of transfer from conformation X to Y";
  Real n(start=falpha(0)/(falpha(0) + fbeta(0)), fixed=true) "ratio of molecules in conformation X";
  outer SI.ElectricPotential v_gate "membrane potential of enclosing component";
  Real alpha(unit="1") = falpha(v_gate);
  Real beta(unit="1") = fbeta(v_gate);
  Real steady(unit="1") = alpha / (alpha + beta);
  Real tau(unit="1") = 1 / (alpha + beta);
equation
  der(n) = alpha * (1 - n) - beta * n;
annotation(
  Icon(graphics = {Text(origin = {-1, -41}, extent = {{-29, 31}, {29, -31}}, textString = "α/β")})
);
end GateAB;

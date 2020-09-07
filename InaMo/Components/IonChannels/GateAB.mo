within InaMo.Components.IonChannels;
model GateAB "gating molecule with two conformations/positions X and Y governed by two functions alpha and beta"
  extends InaMo.Icons.Gate;
  import InaMo.Components.Functions.Fitting.*;
  replaceable function falpha = goldmanFit(x0=0, sx=1, sy=1) "rate of transfer from conformation Y to X";
  replaceable function fbeta = scaledExpFit(x0=0, sx=1, sy=1) "rate of transfer from conformation X to Y";
  Real n(start=falpha(0)/(falpha(0) + fbeta(0)), fixed=true) "ratio of molecules in conformation X";
  outer SI.ElectricPotential v_gate "membrane potential of enclosing component";
equation
  der(n) = falpha(v_gate) * (1 - n) - fbeta(v_gate) * n;
annotation(
  Icon(graphics = {Text(origin = {-1, -41}, extent = {{-29, 31}, {29, -31}}, textString = "α/β")})
);
end GateAB;

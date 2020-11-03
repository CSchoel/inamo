within InaMo.Components.IonCurrents;
model GateTS "gating molecule with two conformations/positions X and Y governed by two functions tau and steady"
  extends InaMo.Icons.Gate;
  import InaMo.Components.Functions.Fitting.*;
  replaceable function ftau = generalizedLogisticFit "time until difference between n and fsteady(v_gate) has reduced by a factor of 1/e if v_gate is held constant";
  replaceable function fsteady = generalizedLogisticFit "value that n would reach if v_gate is held constant";
  Real n(start=fsteady(0), fixed=true) "ratio of molecules in open conformation";
  outer SI.ElectricPotential v_gate "membrane potential of enclosing component";
  Real steady = fsteady(v_gate);
  Real tau = ftau(v_gate);
equation
  der(n) = (steady - n) / tau;
annotation(
  Icon(graphics = {Text(origin = {-1, -41}, extent = {{-29, 31}, {29, -31}}, textString = "τ/∞")})
);
end GateTS;

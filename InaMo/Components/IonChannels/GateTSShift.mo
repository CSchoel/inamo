within InaMo.Components.IonChannels;
model GateTSShift "like GateTS but with an additional variable that shifts the steady state curve along the x axis"
  // TODO should this and GateTS have a common baseclass?
  // probably yes once we are sure that GateTSShift is here to stay
  import InaMo.Components.FittingFunctions.*;
  replaceable function ftau = generalizedLogisticFit "time until difference between n and fsteady(v_gate) has reduced by a factor of 1/e if v_gate is held constant";
  replaceable function fsteady = generalizedLogisticFit "value that n would reach if v_gate is held constant";
  Real n(start=fsteady(0), fixed=true) "ratio of molecules in open conformation";
  outer SI.ElectricPotential v_gate "membrane potential of enclosing component";
  SI.ElectricPotential shift;
equation
  der(n) = (fsteady(v_gate - shift) - n)/ftau(v_gate);
end GateTSShift;
within InaMo.Components.IonChannels;
partial model IonChannel
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  import Modelica.SIunits.*;
  Conductance G "ion conductance";
  parameter ElectricPotential V_eq "equilibrium potential";
  parameter Conductance G_max "maximum conductance";
equation
  p.I = G * (V - V_eq);
end IonChannel;

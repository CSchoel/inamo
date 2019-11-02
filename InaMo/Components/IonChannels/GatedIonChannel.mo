within InaMo.Components.IonChannels;
partial model GatedIonChannel "ion channel with voltage dependent gates"
  extends Modelica.Electrical.Analog.Interfaces.OnePort;
  parameter SI.ElectricPotential V_eq "equilibrium potential";
  Real open_ratio "ratio between 0 (fully closed) and 1 (fully open)";
  Real i_open "i if open_ratio = 1";
equation
  i = open_ratio * i_open;
end GatedIonChannel;

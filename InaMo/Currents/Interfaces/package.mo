within InaMo.Currents;
package Interfaces "interfaces for cell membrane currents"
  extends Modelica.Icons.InterfacesPackage;
annotation(Documentation(info="<html>
  <p>The current-defining models in InaMo are compatible to Modelica.Electric
  and sometimes use other models from this library.
  This is achived with the interfaces InaMo.Currents.Interfaces.TwoPinCell,
  InaMo.Currents.Interfaces.TwoPinVertical and
  InaMo.Currents.Interfaces.OnePortVertical, which are all copies of
  interfaces from Modelica.Electric.Interfaces, which only change the connector
  placement.</p>
  <p>Membrane components always have a positive pin at the top representing
  the extracellular potential and a negative pin at the bottom representing
  the intracellular potential.
  InaMo.Currents.Interfaces.TwoPinCell places the connectors more freely to
  visually put them on the outside and inside of the cell in the icon.</p>
</html>"));
end Interfaces;

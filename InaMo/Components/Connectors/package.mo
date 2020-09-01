within InaMo.Components;
package Connectors
  extends Modelica.Icons.InterfacesPackage;
  connector TemperatureInput = input SI.Temperature "membrane temperature";
  connector TemperatureOutput = output SI.Temperature "membrane temperature";
  connector IonConcentration
    SI.Concentration c;
    flow Real rate(unit="mol.m-3.s-1");
  end IonConcentration;
end Connectors;

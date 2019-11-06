within InaMo.Components;
package Connectors
  connector TemperatureInput = input SI.Temperature "membrane temperature";
  connector TemperatureOutput = output SI.Temperature "membrane temperature";
  record MobileIon
    SI.Concentration c_in "concentration inside the cell";
    SI.Concentration c_ex "concentration outside the cell";
    SI.Permeability p "permeability of membrane for ion";
    Integer z "valence of the ion";
  end MobileIon;
end Connectors;

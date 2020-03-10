within InaMo.Components;
package Connectors
  connector TemperatureInput = input SI.Temperature "membrane temperature";
  connector TemperatureOutput = output SI.Temperature "membrane temperature";
  record MobileIon
    SI.Concentration c_in "concentration inside the cell in mol/m³";
    SI.Concentration c_ex "concentration outside the cell in mol/m³";
    PermeabilityFM p "permeability of membrane for ion in m² (fluid mechanics)";
    Integer z "valence of the ion";
  end MobileIon;
  connector IonConcentration
    SI.Concentration c;
    flow SI.Concentration rate;
  end IonConcentration;
end Connectors;

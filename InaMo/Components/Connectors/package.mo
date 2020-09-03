within InaMo.Components;
package Connectors
  extends Modelica.Icons.InterfacesPackage;
  connector TemperatureInput = input SI.Temperature "membrane temperature";
  connector TemperatureOutput = output SI.Temperature "membrane temperature";
  connector IonConcentration
    SI.Concentration c;
    flow Real rate(unit="mol.m-3.s-1");
  end IonConcentration;
  connector CalciumConcentration = IonConcentration annotation(
    Icon(
      graphics = {
        Ellipse(
          origin = {-124, 2145.04}, fillColor = {239, 239, 239},
          fillPattern = FillPattern.Solid, lineThickness = 2.38,
          extent = {{23.29, -2095.81}, {225.49, -2194.76}}
        )
      }
    )
  );
  connector SodiumConcentration = IonConcentration;
  connector PotassiumConcentration = IonConcentration;
  type BufferOccupancy = Real(quantity="ratio", unit="1") "fractional occupancy of buffer";
  connector BufferOccupancyIn = input BufferOccupancy annotation(
    Icon(
      graphics = {
        Ellipse(
          origin = {0, 0},
          fillColor = {170, 170, 255},
          pattern = LinePattern.None,
          fillPattern = FillPattern.Solid,
          extent = {{-100, 100}, {100, -100}},
          startAngle = -22.5, endAngle = 22.5
        )
      }
    )
  );
  connector BufferOccupancyOut = output BufferOccupancy annotation(
    Icon(
      graphics = {
        Ellipse(
          origin = {0, 0},
          fillColor = {170, 170, 255},
          pattern = LinePattern.None,
          fillPattern = FillPattern.Solid,
          extent = {{-100, 100}, {100, -100}},
          startAngle = 22.5, endAngle = 337.5
        )
      }
    )
  );
end Connectors;

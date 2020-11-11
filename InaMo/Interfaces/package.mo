within InaMo;
package Interfaces
  extends Modelica.Icons.InterfacesPackage;
  connector IonSite
    SI.AmountOfSubstance amount;
    SI.MolarFlow rate;
  end IonSite;
  connector CalciumSite = IonSite annotation(
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
  connector SodiumSite = IonSite;
  connector PotassiumSite = IonSite;
  connector MagnesiumSite = IonSite annotation(
    Icon(
      graphics = {
        Ellipse(
          origin = {0, 0}, fillColor = {200, 200, 200},
          fillPattern = FillPattern.Solid, lineThickness = 0.25,
          extent = {{-100, 100}, {100, -100}}
        )
      }
    )
  );
  type BufferOccupancy = Real(quantity="ratio", unit="1") "fractional occupancy of buffer";
  connector BufferOccupancyIn = input BufferOccupancy annotation(
    Icon(
      graphics = {
        Ellipse(
          origin = {-100, 0},
          fillColor = {170, 170, 255},
          pattern = LinePattern.Solid,
          lineThickness = 0.25,
          fillPattern = FillPattern.Solid,
          extent = {{-200, 200}, {200, -200}},
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
          pattern = LinePattern.Solid,
          lineThickness = 0.25,
          fillPattern = FillPattern.Solid,
          extent = {{-100, 100}, {100, -100}},
          startAngle = 22.5, endAngle = 337.5
        )
      }
    )
  );
end Interfaces;

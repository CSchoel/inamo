within InaMo.Concentrations;
package Interfaces "interface components for concentration handling"
  extends Modelica.Icons.InterfacesPackage;
  connector IonSite "general connector for transferring ions"
    SI.AmountOfSubstance amount(nominal=1e-21);
    flow SI.MolarFlowRate rate(nominal=1e-17);
  end IonSite;
  connector CalciumSite = IonSite "connector for transferring Ca2+ ions" annotation(
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
end Interfaces;

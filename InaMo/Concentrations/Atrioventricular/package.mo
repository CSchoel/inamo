within InaMo.Concentrations;
package Atrioventricular "components for concentration handling in atrioventricular cell models"
  import InaMo.Concentrations.Basic.*;
  import InaMo.Concentrations.Interfaces.*;
  extends Modelica.Icons.Package;
annotation(
  Icon(
    graphics = {
      Text(extent={{-90,-90}, {-30,90}}, textString="A"),
      Text(extent={{-30,-90}, {30,90}}, textString="V"),
      Text(extent={{30,-90}, {90,90}}, textString="N")
    }
  )
);
end Atrioventricular;

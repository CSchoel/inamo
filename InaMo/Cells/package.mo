within InaMo;
package Cells "models of full cells"
  extends Modelica.Icons.Package;
  extends InaMo.Icons.Cell annotation(IconMap(extent={{-80,-80}, {80,80}}));
  import InaMo.Functions.Biochemical.*;
  import InaMo.Units.*;
annotation(Documentation(info="<html>
  <p>This package contains the full cell models used in Inada 2009.</p>
  <p>Probably, most experiments by Inada et al. were performed with the model
  variants in VariableCa.</p>
</html>"));
end Cells;

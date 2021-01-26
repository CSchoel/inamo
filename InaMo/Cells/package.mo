within InaMo;
package Cells "models of full cells"
  extends Modelica.Icons.VariantsPackage;
  import InaMo.Components.*;
  import InaMo.Components.IonCurrents.*;
  import InaMo.Concentrations.Atrial.*;
  import InaMo.Concentrations.Atrioventricular.*;
  import InaMo.Functions.Biochemical.*;
annotation(Documentation(info="<html>
  <p>This package contains the full cell models used in Inada 2009.</p>
  <p>
    The models of the three AVN cell types (AN, N, NH) all have base models,
    which capture common structure.
    CellBase is used for all AVN cell types, ANCellBase for all AN cell models
    (i.e. ANCellConst with constant intracellular Ca2+ and ANCell with
    variable Ca2+ influenced by the SR), and for N and NH cells the structure
    is analogous.
  </p>
</html>"));
end Cells;

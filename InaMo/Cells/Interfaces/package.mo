within InaMo.Cells;
package Interfaces "base models of cells"
  extends Modelica.Icons.InterfacesPackage;
annotation(Documentation(info="<html>
  <p>
    This package contains base models of the three AVN cell types
    (AN, N, NH), which capture common structure.
    CellBase is used for all AVN cell types, ANCellBase for all AN cell models
    (i.e. ANCellConst with constant intracellular Ca2+ and ANCell with
    variable Ca2+ influenced by the SR), and for N and NH cells the structure
    is analogous.
  </p>
</html>"));
end Interfaces;

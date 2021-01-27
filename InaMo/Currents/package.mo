within InaMo;
package Currents
  extends Modelica.Icons.Package;
  extends InaMo.Icons.LipidBilayerWithGap annotation(IconMap(extent={{-80,-80},{80,80}}));
  import InaMo.Functions.Fitting.*;
  import InaMo.Functions.Biochemical.*;
  // FIXME
  // We should import InaMo.Concentrations.Interfaces.* here, but this
  // introduces a cyclic import structure where the imports of this package
  // can only be resolved after it has itself been imported in another package.
  // I do not think this should be a problem for a compiler, but apparently
  // it is for OMC. : /

  // import InaMo.Concentrations.Interfaces.*;
end Currents;

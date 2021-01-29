within InaMo;
package Currents "models representing transmembrane ion currents"
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
annotation(Documentation(info="<html>
  <p>This package contains ion channels as well as ion pumps.</p>
  <p>The ion channels follow the typical Hodgkin-Huxley equations, which are
  defined by the base model InaMo.Currents.Interfaces.IonChannelElectric and
  the gate models InaMo.Currents.Basic.GateAB and  InaMo.Currents.Basic.GateTS.
  They make heavy use of the fitting functions in InaMo.Functions.Fitting.
  Since the equations reported in Inada 2009 often either use different units
  or already employ simplifications to the general structure of the fitting
  functions, we sometimes do not give the fittig parameters as a constant
  value but supply the full equation required to transform the value found
  in the article to the value required in this model.
  This is done to allow the reader to trace back values found in this code
  to the equations presented in the original article.</p>
</html>"));
end Currents;

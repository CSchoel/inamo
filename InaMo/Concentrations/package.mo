within InaMo;
package Concentrations "models governing changes in ion concentrations"
  extends Modelica.Icons.Package;
  extends InaMo.Icons.Compartment;
  import InaMo.Functions.Biochemical.*;
  import InaMo.Currents.Interfaces.*;
annotation(Documentation(info="<html>
  <p>The models in this package mainly concern the Ca2+ handling by the
  sarcoplasmic reticulum and various Ca2+ buffers, but the package
  InaMo.Concentrations.Interfaces also contains some general models that
  can be used in ion currents, whose associated ion concentrations are
  variable.</p>
</htmL>"));
end Concentrations;

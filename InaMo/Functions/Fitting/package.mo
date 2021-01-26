within InaMo.Functions;
package Fitting "contains fitting functions"
  extends Modelica.Icons.FunctionsPackage;
annotation(Documentation(info="<html>
  <p>This package contains fitting functions used to fit the behavior of
  ion pumps and the gating variables of ion channels to experimental data.
  Instead of copying the equations for each component individually, these
  functions can be used to give the arbitrary constants in these functions
  and the structure of the equations at least some intuitive meaning.</p>
  <p>The parameters of the functions which are fixed fitting parameters
  always have a default value and are identified by the string
  &quot;(fitting parameter)&quot; as part of their documentation string.</p>
</html>"));
end Fitting;

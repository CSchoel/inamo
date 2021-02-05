within InaMo;
package Units "units and constants which are not in Modelica.SIUnits"
  extends Modelica.Icons.TypesPackage;
  type PermeabilityFM = Modelica.Icons.TypeReal(
    final quantity="Permeability (fluid mechanics)",
    final unit="m3/(s.m2)"
  );
  constant SI.Area unitArea = 1;
end Units;

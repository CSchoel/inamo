within InaMo.Examples.ComponentTests;
model GHKFlux "small example to test validity of ghkFlux for v=0"
  extends Modelica.Icons.Example;
  import InaMo.Functions.Biochemical.ghkFlux;
  SI.Voltage v(start=-0.02, fixed=true) "input voltage";
  parameter SI.Temperature temp = SI.Conversions.from_degC(37) "membrane temperature";
  parameter SI.Concentration na_in = 8.4 "intracellular sodium concentration";
  parameter SI.Concentration na_ex = 75 "extracellular sodium concentration";
  parameter PermeabilityFM na_p = 1.4e-15*1.5 "membrane permeability for Na+";
  SI.CurrentDensity flux = ghkFlux(v, temp, na_in, na_ex, na_p, 1) "current density for input voltage";
  SI.CurrentDensity flux0 = ghkFlux(0,  temp, na_in, na_ex, na_p, 1) "current density at 0 V";
equation
  der(v) = 0.001;
end GHKFlux;

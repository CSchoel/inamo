within InaMo.Examples;
model GHKFlux "small example to test validity of ghkFlux for v=0"
  import InaMo.Components.Functions.ghkFlux;
  Real v(start=-0.02, fixed=true);
  parameter SI.Temperature temp = SI.Conversions.from_degC(37);
  parameter SI.Concentration na_in = 8.4;
  parameter SI.Concentration na_ex = 75;
  parameter PermeabilityFM na_p = 1.4e-15*1.5;
  Real flux = ghkFlux(v, temp, na_in, na_ex, na_p, 1);
  Real flux0 = ghkFlux(0,  temp, na_in, na_ex, na_p, 1);
equation
  der(v) = 0.001;
end GHKFlux;

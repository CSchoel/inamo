within InaMo.Examples;
model GHKFlux "small example to test validity of ghkFlux for v=0"
  import InaMo.Components.Connectors.MobileIon;
  import InaMo.Components.Functions.ghkFlux;
  Real v(start=-0.02, fixed=true);
  parameter SI.Temperature T = SI.Conversions.from_degC(37);
  parameter MobileIon sodium(c_in=8.4, c_ex=75, p=1.4e-15*1.5, z=1);
  Real flux = ghkFlux(v, T, sodium);
  Real flux0 = ghkFlux(0, T, sodium);
equation
  der(v) = 0.001;
end GHKFlux;

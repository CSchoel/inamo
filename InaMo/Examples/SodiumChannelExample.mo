within InaMo.Examples;
model SodiumChannelExample
  SodiumChannel c(
    ion=sodium,
    T=T
  );
  parameter MobileIon sodium = MobileIon(0.008, 0.14, 1.4e-9, 1);
  parameter Real T = 310;
  Modelica.Electrical.Analog.Sources.ConstantVoltage stim(V = 0.050);
  Modelica.Electrical.Analog.Basic.Ground g;
  // TODO create voltage clamp as helper model
equation
  connect(c.p, stim.n);
  connect(stim.p, c.n);
  connect(stim.n, g.p);
end SodiumChannelExample;

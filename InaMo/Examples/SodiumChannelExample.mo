within InaMo.Examples;
model SodiumChannelExample
  SodiumChannel c(
    P=1.4e-9,
    C_ex=Na_ex,
    V_eq=Modelica.Constants.R * T / Modelica.Constants.F * log(Na_ex/Na_in),
    T=T
  );
  parameter Real Na_ex = 0.14;
  parameter Real Na_in = 0.008;
  parameter Real T = 310;
  Modelica.Electrical.Analog.Sources.ConstantVoltage stim(V = 0.040);
  Modelica.Electrical.Analog.Basic.Ground g;
  // TODO create voltage clamp as helper model
equation
  connect(c.p, stim.n);
  connect(stim.p, c.n);
  connect(stim.n, g.p);
end SodiumChannelExample;

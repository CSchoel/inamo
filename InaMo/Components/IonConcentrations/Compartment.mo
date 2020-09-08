within InaMo.Components.IonConcentrations;
model Compartment "compartment that has an ion concentration"
  extends InaMo.Icons.Compartment;
  replaceable connector ConcentrationType = CalciumConcentration;
  ConcentrationType c annotation(Placement(transformation(extent = {{-15, -115}, {15, -85}})));
  parameter SI.Volume vol "volume of the compartment";
  parameter SI.Concentration c_start = 1 "initial value of concentration";
initial equation
  c.c = c_start;
equation
  der(c.c) = c.rate;
annotation(
  Icon(graphics = {Text(origin = {-54, 67}, extent = {{104, -25}, {-2, 3}}, textString = "%name")})
);
end Compartment;

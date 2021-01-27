within InaMo.Concentrations.Basic;
model Compartment "compartment that has an ion concentration"
  extends InaMo.Icons.Compartment;
  replaceable connector SubstanceSite = CalciumSite;
  SubstanceSite substance annotation(Placement(transformation(extent = {{-15, -115}, {15, -85}})));
  parameter SI.Volume vol "volume of the compartment";
  parameter SI.Concentration c_start = 1 "initial value of concentration";
  SI.Concentration con = substance.amount / vol;
initial equation
  substance.amount = c_start * vol;
equation
  der(substance.amount) = substance.rate;
annotation(
  Icon(graphics = {Text(origin = {-54, 67}, extent = {{104, -25}, {-2, 3}}, textString = "%name")})
);
end Compartment;

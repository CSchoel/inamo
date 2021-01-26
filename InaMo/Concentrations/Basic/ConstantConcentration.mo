within InaMo.Components.IonConcentrations;
model ConstantConcentration "ion concentration with constant value"
  extends InaMo.Icons.Compartment;
  replaceable connector SubstanceSite = CalciumSite;
  SubstanceSite substance annotation(Placement(transformation(extent = {{-15, -115}, {15, -85}})));
  parameter SI.Concentration c_const = 1 "fixed concentration";
  parameter SI.Volume vol = 1 "volume of the compartment";
equation
  substance.amount = c_const * vol;
annotation(
  Icon(graphics = {
    Text(origin = {-54, 67}, extent = {{104, -25}, {-2, 3}}, textString = "%name"),
    Text(origin = {-81, 0}, rotation = 90, extent = {{-99, 10}, {99, -12}}, textString = "%c_const")
  })
);
end ConstantConcentration;

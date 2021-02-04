within InaMo.Concentrations.Basic;
model Compartment "compartment that holds an ion concentration"
  extends InaMo.Icons.Compartment;
  InaMo.Concentrations.Interfaces.SubstanceSite substance "substance in the compartment" annotation(Placement(transformation(extent = {{-15, -115}, {15, -85}})));
  parameter SI.Volume vol "volume of the compartment";
  parameter SI.Concentration c_start = 1 "initial value of concentration";
  SI.Concentration con = substance.amount / vol "concentration of substance in compartment";
initial equation
  substance.amount = c_start * vol;
equation
  der(substance.amount) = substance.rate;
annotation(
  Documentation(info="<html>
    <p>This model can be used to combine multiple influences on a single
    substance concentration/amount in a compartment.
    Individual effects can be introduced by adding a connection to the
    connector <code>substance</code>.</p>
  </html>"),
  Icon(graphics = {Text(origin = {-54, 67}, extent = {{104, -25}, {-2, 3}}, textString = "%name")})
);
end Compartment;

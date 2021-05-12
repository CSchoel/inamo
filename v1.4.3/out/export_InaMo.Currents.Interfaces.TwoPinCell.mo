partial model TwoPinCell "Copy of Modelica.Electrical.Interfaes.TwoPin with adjusted connector placement"
  SI.Voltage v "Voltage drop of the two pins (= p.v - n.v)";
  Modelica.Electrical.Analog.Interfaces.PositivePin p(v.nominal = 1e-3, i.nominal = 1e-12) "Positive electrical pin" annotation(
    Placement(transformation(extent = {{-60, 110}, {-40, 90}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n(v.nominal = 1e-3, i.nominal = 1e-12) "Negative electrical pin" annotation(
    Placement(transformation(extent = {{-60, -10}, {-40, 10}})));
equation
  v = p.v - n.v;
end TwoPinCell;
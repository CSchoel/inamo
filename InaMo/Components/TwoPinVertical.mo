within InaMo.Components;
partial model TwoPinVertical
  "Copy of Modelica.Electrical.Interfaes.TwoPin with vertical connector placement"

  SI.Voltage v "Voltage drop of the two pins (= p.v - n.v)";
  PositivePin p "Positive electrical pin"
    annotation (Placement(transformation(extent={{-10,110},{10,90}})));
  NegativePin n "Negative electrical pin"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
equation
  v = p.v - n.v;
end TwoPinVertical;

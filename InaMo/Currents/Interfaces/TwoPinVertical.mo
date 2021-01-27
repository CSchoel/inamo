within InaMo.Currents.Interfaces;
partial model TwoPinVertical
  "Copy of Modelica.Electrical.Interfaes.TwoPin with vertical connector placement"

  SI.Voltage v "Voltage drop of the two pins (= p.v - n.v)";
  Modelica.Electrical.Analog.Interfaces.PositivePin p(v.nominal=1e-3, i.nominal=1e-12) "Positive electrical pin"
    annotation (Placement(transformation(extent={{-10,110},{10,90}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n(v.nominal=1e-3, i.nominal=1e-12) "Negative electrical pin"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
equation
  v = p.v - n.v;
end TwoPinVertical;

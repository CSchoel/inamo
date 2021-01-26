within InaMo.Interfaces;
partial model OnePortVertical
  "Copy of Modelica.Electrical.Interfaes.OnePort with vertical connector placement"

  SI.Voltage v "Voltage drop of the two pins (= p.v - n.v)";
  SI.Current i "Current flowing from pin p to pin n";
  Modelica.Electrical.Analog.Interfaces.PositivePin p(v.nominal=1e-3, i.nominal=1e-12) "Positive electrical pin"
    annotation (Placement(transformation(extent={{-10,110},{10,90}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin n(v.nominal=1e-3, i.nominal=1e-12) "Negative electrical pin"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
equation
  v = p.v - n.v;
  0 = p.i + n.i;
  i = p.i;
end OnePortVertical;

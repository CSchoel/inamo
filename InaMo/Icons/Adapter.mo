within InaMo.Icons;
model Adapter "InterfacesPackage icon without package background"
annotation(Icon(graphics={
  Polygon(
    origin={20.0,0.0},
    lineColor={64,64,64},
    fillColor={255,255,255},
    fillPattern=FillPattern.Solid,
    points={{-10.0,70.0},{10.0,70.0},{40.0,20.0},{80.0,20.0},{80.0,-20.0},{40.0,-20.0},{10.0,-70.0},{-10.0,-70.0}}
  ),
  Polygon(
    fillColor={102,102,102},
    pattern=LinePattern.None,
    fillPattern=FillPattern.Solid,
    points={{-100.0,20.0},{-60.0,20.0},{-30.0,70.0},{-10.0,70.0},{-10.0,-70.0},{-30.0,-70.0},{-60.0,-20.0},{-100.0,-20.0}}
  )
}));
end Adapter;

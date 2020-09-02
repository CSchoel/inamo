within InaMo.Icons;
model PartialExample
  annotation (
    Icon(
      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.None,
                linePattern = LinePattern.Dash,
                extent = {{-100,-100},{100,100}}
        ),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Forward,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}}
        )
      }
    )
  );
end PartialExample;

within InaMo.Icons;
model PartialExample
  annotation (
    Icon(
      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.None,
                pattern = LinePattern.Dash,
                extent = {{-100,-100},{100,100}}
        ),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.Dash,
                points = {{-31,55},{59,0},{-31,-55},{-31,55}}
        )
      }
    )
  );
end PartialExample;

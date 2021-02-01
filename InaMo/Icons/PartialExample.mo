within InaMo.Icons;
model PartialExample "like Modelica.Icons.Example, but with dotted lines"
  annotation (
    Icon(
      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(lineColor = {75,138,73},
                pattern = LinePattern.Dash,
                extent = {{-100,-100},{100,100}}
        ),
        Polygon(lineColor = {75,138,73},
                pattern = LinePattern.Dash,
                points = {{-31,55},{59,0},{-31,-55},{-31,55}}
        )
      }
    )
  );
end PartialExample;

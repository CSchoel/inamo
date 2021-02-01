within InaMo.Icons;
model InsideBottomOutsideTop "grey rectangle covering the lower 2/3 of the icon"
annotation(
  Icon(
    coordinateSystem(
      preserveAspectRatio= false,
      extent= {{-100,-100},{100,100}}
    ),
    graphics= {
      Rectangle(
        origin= {0,0},
        pattern= LinePattern.None,
        fillPattern= FillPattern.Solid,
        fillColor= {230,230,230},
        extent= {{-100,47},{100,-100}}
      )
    }
  )
);
end InsideBottomOutsideTop;

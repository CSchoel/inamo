within InaMo.Icons;
model InsideTopOutsideBottom
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
        extent= {{-100,100},{100,-47}}
      )
    }
  )
);
end InsideTopOutsideBottom;

within InaMo.Icons;
model OpenChannel "pore that is open on both sides"
annotation(
  Icon(
    coordinateSystem(
      preserveAspectRatio= false,
      extent= {{-100,-100},{100,100}}
    ),
    graphics= {
      Polygon(
        origin= {-100,2145.04},
        lineThickness= 0.25,
        pattern= LinePattern.Solid,
        points= {{62.67, -2098.02}, {62.67, -2192.80}, {76.96, -2192.80}, {82.99, -2186.78}, {82.99, -2145.04}, {82.99, -2115.02}, {82.99, -2098.02}},
        fillPattern= FillPattern.Solid,
        fillColor= {124,154,239},
        lineColor= {0,0,0},
        rotation= -0
      ),
      Polygon(
        origin= {-100,2145.04},
        lineThickness= 0.25,
        pattern= LinePattern.Solid,
        points= {{137.43, -2098.02}, {137.43, -2192.80}, {123.13, -2192.80}, {117.11, -2186.78}, {117.11, -2145.04}, {117.11, -2115.02}, {117.11, -2098.02}},
        fillPattern= FillPattern.Solid,
        fillColor= {124,154,239},
        lineColor= {0,0,0},
        rotation= -0
      )
    }
  )
);
end OpenChannel;

within InaMo.Icons;
model SarcoplasmicReticulum
    annotation(
        Icon(
            coordinateSystem(
                extent= {{-100,-100},{100,100}},
                preserveAspectRatio= false
            ),
            graphics= {
                Rectangle(
                    extent= {{0,0},{200,-200}},
                    fillColor= {230,230,230},
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.25,
                    origin= {-100,100},
                    pattern= LinePattern.None
                ),
                Ellipse(
                    extent= {{55.83,0},{200,-200}},
                    fillColor= {213,213,213},
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.25,
                    origin= {-100,100},
                    pattern= LinePattern.None
                ),
                Polygon(
                    lineThickness= 0.25,
                    origin= {-100,100},
                    points= {{171.31, -79}, {157.99, -79}, {115.86, -79}, {103.58, -79}, {103.58, -65.41}, {60.28, -65.41}, {60.28, -79}, {60.28, -121}, {60.28, -134.59}, {103.58, -134.59}, {103.58, -121}, {115.86, -121}, {157.99, -121}, {171.31, -121}, {171.31, -108}, {171.31, -92}},
                    smooth= Smooth.Bezier
                ),
                Text(
                    extent= {{122.69,-78.73},{152.36,-99.53}},
                    fontSize= 0,
                    horizontalAlignment= TextAlignment.Left,
                    lineThickness= 0.25,
                    origin= {-100,100},
                    pattern= LinePattern.Solid,
                    textString= "NSR"
                ),
                Text(
                    extent= {{68.76,-65.34},{98.42,-86.14}},
                    fontSize= 0,
                    horizontalAlignment= TextAlignment.Left,
                    lineThickness= 0.25,
                    origin= {-100,100},
                    pattern= LinePattern.Solid,
                    textString= "JSR"
                ),
                Line(
                    arrow= {Arrow.None, Arrow.Open},
                    arrowSize= 0.265,
                    origin= {-100,100},
                    points= {{141.15, -155.19}, {141.15, -106.74}},
                    thickness= 0.5
                ),
                Line(
                    arrow= {Arrow.None, Arrow.Open},
                    arrowSize= 0.265,
                    origin= {-100,100},
                    points= {{115.80, -100}, {91.14, -100}},
                    thickness= 0.5
                ),
                Line(
                    arrow= {Arrow.None, Arrow.Open},
                    arrowSize= 0.265,
                    origin= {-100,100},
                    points= {{74.02, -100}, {28.07, -100}},
                    thickness= 0.5
                ),
                Line(
                    arrow= {Arrow.None, Arrow.Open},
                    arrowSize= 0.265,
                    origin= {-100,100},
                    points= {{0, -119.18}, {0, -167.26}, {108.91, -167.26}},
                    thickness= 0.5
                ),
                Polygon(
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.80,
                    origin= {-100,100},
                    pattern= LinePattern.None,
                    points= {{141.15, -102.12}, {145.15, -109.05}, {137.14, -109.05}}
                ),
                Polygon(
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.80,
                    origin= {-100,100},
                    pattern= LinePattern.None,
                    points= {{141.14, -101.06}, {140.68, -101.86}, {136.21, -109.58}, {146.07, -109.58}, {141.14, -101.06}, {144.23, -108.51}, {138.06, -108.51}, {141.14, -103.18}}
                ),
                Polygon(
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.80,
                    origin= {-100,100},
                    pattern= LinePattern.None,
                    points= {{86.52, -100}, {93.45, -95.99}, {93.45, -104.01}}
                ),
                Polygon(
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.80,
                    origin= {-100,100},
                    pattern= LinePattern.None,
                    points= {{93.99, -95.06}, {85.45, -100}, {86.25, -100.47}, {93.99, -104.93}, {93.99, -95.06}, {92.91, -103.07}, {87.59, -100}, {92.91, -96.92}}
                ),
                Polygon(
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.80,
                    origin= {-100,100},
                    pattern= LinePattern.None,
                    points= {{23.45, -100}, {30.38, -95.99}, {30.38, -104.01}}
                ),
                Polygon(
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.80,
                    origin= {-100,100},
                    pattern= LinePattern.None,
                    points= {{30.92, -95.06}, {22.38, -100}, {23.18, -100.47}, {30.92, -104.93}, {30.92, -95.06}, {29.85, -103.08}, {24.52, -100}, {29.85, -96.91}}
                ),
                Polygon(
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.80,
                    origin= {-100,100},
                    pattern= LinePattern.None,
                    points= {{113.53, -167.26}, {106.60, -171.26}, {106.60, -163.25}}
                ),
                Polygon(
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.80,
                    origin= {-100,100},
                    pattern= LinePattern.None,
                    points= {{106.06, -162.33}, {106.06, -172.19}, {114.60, -167.26}, {113.80, -166.79}, {106.06, -162.33}, {112.46, -167.26}, {107.13, -170.34}, {107.13, -164.17}}
                )
            }
        )
    );
end SarcoplasmicReticulum;

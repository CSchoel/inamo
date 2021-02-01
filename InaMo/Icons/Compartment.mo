within InaMo.Icons;
model Compartment "stylized beaker with fluid and circles in the fluid"
    annotation(
        Icon(
            coordinateSystem(
                extent= {{-100,-100},{100,100}},
                preserveAspectRatio= false
            ),
            graphics= {
                Rectangle(
                    extent= {{43.21,-87.23},{159.09,-200}},
                    fillColor= {195,231,251},
                    fillPattern= FillPattern.Solid,
                    origin= {-104.99,122.42},
                    pattern= LinePattern.None
                ),
                Polygon(
                    lineColor= {0,0,0},
                    lineThickness= 1,
                    origin= {-104.99,122.42},
                    points= {{43.21, -44.12}, {43.21, -200}, {159.09, -200}, {159.09, -61.75}, {173.47, -43.13}}
                ),
                Line(
                    origin= {-104.99,122.42},
                    points= {{159.09, -160}, {147.57, -160}},
                    thickness= 1
                ),
                Line(
                    origin= {-104.99,122.42},
                    points= {{159.09, -120}, {147.57, -120}},
                    thickness= 1
                ),
                Line(
                    origin= {-104.99,122.42},
                    points= {{159.09, -80}, {147.57, -80}},
                    thickness= 1
                ),
                Line(
                    origin= {-104.99,122.42},
                    points= {{159.09, -100}, {143.38, -100}},
                    thickness= 1
                ),
                Line(
                    origin= {-104.99,122.42},
                    points= {{159.09, -140}, {147.57, -140}},
                    thickness= 1
                ),
                Line(
                    origin= {-104.99,122.42},
                    points= {{159.09, -180}, {147.57, -180}},
                    thickness= 1
                ),
                Ellipse(
                    extent= {{56.49,-150.09},{71.61,-165.21}},
                    fillColor= {145,204,255},
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.25,
                    origin= {-104.99,122.42}
                ),
                Ellipse(
                    extent= {{64.96,-105.20},{80.08,-120.31}},
                    fillColor= {145,204,255},
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.25,
                    origin= {-104.99,122.42}
                ),
                Ellipse(
                    extent= {{122.75,-139.04},{137.87,-154.16}},
                    fillColor= {145,204,255},
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.25,
                    origin= {-104.99,122.42}
                ),
                Ellipse(
                    extent= {{115.91,-176.98},{131.03,-192.10}},
                    fillColor= {145,204,255},
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.25,
                    origin= {-104.99,122.42}
                ),
                Ellipse(
                    extent= {{83.20,-171.32},{98.32,-186.44}},
                    fillColor= {145,204,255},
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.25,
                    origin= {-104.99,122.42}
                ),
                Ellipse(
                    extent= {{109.93,-105.37},{125.05,-120.49}},
                    fillColor= {145,204,255},
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.25,
                    origin= {-104.99,122.42}
                ),
                Ellipse(
                    extent= {{88.64,-136.35},{103.76,-151.46}},
                    fillColor= {145,204,255},
                    fillPattern= FillPattern.Solid,
                    lineThickness= 0.25,
                    origin= {-104.99,122.42}
                )
            }
        )
    );
end Compartment;

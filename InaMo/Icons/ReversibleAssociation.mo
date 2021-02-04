within InaMo.Icons;
model ReversibleAssociation
  annotation(
      Icon(
          coordinateSystem(
              extent= {{-100,-100},{100,100}},
              preserveAspectRatio= false
          ),
          graphics= {
              Ellipse(
                  extent= {{-15,-32.78},{15,-62.78}},
                  fillPattern= FillPattern.Solid,
                  origin= {-100,100},
                  pattern= LinePattern.None
              ),
              Ellipse(
                  extent= {{-15,-130.43},{15,-160.43}},
                  fillPattern= FillPattern.Solid,
                  origin= {-100,100},
                  pattern= LinePattern.None
              ),
              Ellipse(
                  extent= {{185.50,-85},{215.50,-115}},
                  fillPattern= FillPattern.Solid,
                  origin= {-100,100},
                  pattern= LinePattern.None
              ),
              Ellipse(
                  extent= {{0,-11.32},{72.93,-84.25}},
                  fillColor= {137,137,137},
                  fillPattern= FillPattern.Solid,
                  lineThickness= 1,
                  origin= {-100,100}
              ),
              Ellipse(
                  extent= {{0,-123.96},{42.93,-166.90}},
                  fillColor= {137,137,137},
                  fillPattern= FillPattern.Solid,
                  lineThickness= 1,
                  origin= {-100,100}
              ),
              Ellipse(
                  extent= {{127.07,-63.53},{200,-136.47}},
                  fillColor= {137,137,137},
                  fillPattern= FillPattern.Solid,
                  lineThickness= 1,
                  origin= {-100,100}
              ),
              Ellipse(
                  extent= {{142.07,-42.07},{185,-85}},
                  fillColor= {137,137,137},
                  fillPattern= FillPattern.Solid,
                  lineThickness= 1,
                  origin= {-100,100}
              ),
              Polygon(
                  fillPattern= FillPattern.Solid,
                  origin= {-100,100},
                  pattern= LinePattern.None,
                  points= {{99.45, -77.55}, {94.50, -82.50}, {99.40, -87.40}, {66.02, -87.40}, {66.02, -94.40}, {116.31, -94.40}, {99.45, -77.55}}
              ),
              Polygon(
                  fillPattern= FillPattern.Solid,
                  origin= {-100,100},
                  pattern= LinePattern.None,
                  points= {{66.02, -104.70}, {82.87, -121.56}, {87.81, -116.60}, {82.93, -111.72}, {116.31, -111.72}, {116.31, -104.70}, {66.02, -104.70}}
              )
          }
      )
  );
end ReversibleAssociation;

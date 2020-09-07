within InaMo.Icons;
model CellConst
  parameter String cell_type = "";
  annotation(
    Icon(graphics = {
      Text(
        origin = {9, -4},
        extent = {{-31, 26}, {41, -34}}, textString = "%cell_type"
      ),
      Line(
        origin = {-11.01, -51.99},
        points = {{-40.9906, -2.00538}, {-22.9906, 19.9946}, {-0.99059, -28.0054}, {21.0094, 19.9946}, {41.0094, -2.00538}},
        thickness = 0.5,
        color = {170, 170, 170},
        smooth = Smooth.Bezier
      ),
      Line(
        origin = {-7.31437, -49.9132},
        points = {{-45, 0}, {37, 0}},
        thickness = 0.5
      )
    })
  );
end CellConst;

within InaMo.Icons;
model CellVar "black sine wave above greyed out flat line"
  parameter String cell_type = "";
  annotation(
    Icon(graphics = {
      Text(
        origin = {9, -4},
        extent = {{-31, 26}, {41, -34}}, textString = "%cell_type"
      ),
      Line(
        origin = {-7.31437, -49.9132},
        points = {{-45, 0}, {37, 0}},
        color = {170, 170, 170},
        thickness = 0.5
      ),
      Line(
        origin = {-11.01, -51.99},
        points = {{-40.9906, -2.00538}, {-22.9906, 19.9946}, {-0.99059, -28.0054}, {21.0094, 19.9946}, {41.0094, -2.00538}},
        thickness = 0.5,
        smooth = Smooth.Bezier
      )
    })
  );
end CellVar;

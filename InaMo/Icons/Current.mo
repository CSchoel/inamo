within InaMo.Icons;
model Current "used to add current name to InaMo.Icons.LipidBilayerWithGap"
  parameter String current_name = "I_x";
  annotation(
    Icon(
      graphics = {
        Text(
          origin = {38, -67},
          extent = {{-32, 11}, {62, -3}},
          textString = "%current_name"
        )
      },
      coordinateSystem(initialScale = 0.1)
    )
  );
end Current;

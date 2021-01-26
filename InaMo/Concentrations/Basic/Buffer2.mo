within InaMo.Components.IonConcentrations;
model Buffer2 "buffer that can bind to two different molecules"
  extends BufferBase;
  BufferOccupancyOut f_out = f "fractional occupancy of buffer by this molecule"
    annotation(Placement(transformation(extent = {{1, -110}, {21, -90}}, rotation = -90)));
  BufferOccupancyIn f_other "fractional occupancy of buffer by other molecule"
    annotation(Placement(transformation(extent = {{49, -110}, {69, -90}}, rotation = -90)));
equation
  der(f) = k * site.amount * (1 - f - f_other) - kb * f;
end Buffer2;

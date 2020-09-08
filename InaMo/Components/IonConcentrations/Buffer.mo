within InaMo.Components.IonConcentrations;
model Buffer "buffer with a single target"
  extends BufferBase;
equation
  der(f) = k * c.c * (1 - f) - kb * f;
end Buffer;

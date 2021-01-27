within InaMo.Concentrations.Basic;
model Buffer "buffer that only binds to a single type of molecule"
  extends BufferBase;
equation
  der(f) = k * site.amount * (1 - f) - kb * f;
end Buffer;

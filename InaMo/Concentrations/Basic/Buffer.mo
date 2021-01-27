within InaMo.Concentrations.Basic;
model Buffer "buffer with a single target"
  extends BufferBase;
equation
  der(f) = k * site.amount * (1 - f) - kb * f;
end Buffer;

within InaMo.Components.Cells;
model NCell
  extends NCellBase;
  CaHandling ca;
equation
  connect(ca.sub.c, cal.ca_sub);
  connect(ca.sub.c, naca.ca_sub);
end NCell;

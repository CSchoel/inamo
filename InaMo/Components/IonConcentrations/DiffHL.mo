within InaMo.Components.IonConcentrations;
model DiffHL "diffusion following Hill-Langmuir kinetics"
  extends DiffusionVol;
  parameter Real p(unit="1/s") "rate coefficient (inverse of time constant)";
  parameter SI.Concentration ka "concentration producing half occupation";
  parameter Real n(unit="1") "Hill coefficient";
equation
  j = (src.amount - dst.amount) * p * hillLangmuir(dst.amount / vol_dst, ka, n);
annotation(
  Icon(graphics = {
    Text(origin = {-33, 30}, extent = {{-3, 14}, {31, -22}}, textString = "HL")
  })
);
end DiffHL;

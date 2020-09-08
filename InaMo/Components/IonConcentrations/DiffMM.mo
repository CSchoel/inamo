within InaMo.Components.IonConcentrations;
model DiffMM "diffusion following Michaelis-Menten kinetics"
  extends DiffusionVol;
  parameter Real p(unit="mol/(m3.s)") "diffusion coefficient";
  parameter SI.Concentration k "Michaelis constant";
equation
  j = p * michaelisMenten(src.c, k);
annotation(
  Icon(graphics = {
    Text(origin = {5, -14}, extent = {{-3, 14}, {31, -22}}, textString = "MM")
  })
);
end DiffMM;

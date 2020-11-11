within InaMo.Components.IonConcentrations;
model DiffMM "diffusion following Michaelis-Menten kinetics"
  extends DiffusionVol;
  parameter SI.MolarFlow p "diffusion coefficient";
  parameter SI.Concentration k "Michaelis constant";
  parameter SI.Volume vol_src "volume of source compartment";
equation
  j = p * michaelisMenten(src.amount / vol_src, k);
annotation(
  Icon(graphics = {
    Text(origin = {5, -14}, extent = {{-3, 14}, {31, -22}}, textString = "MM")
  })
);
end DiffMM;

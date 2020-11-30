within InaMo.Components.IonConcentrations;
model DiffMM "diffusion following Michaelis-Menten kinetics"
  extends InaMo.Interfaces.SubstanceTransport;
  parameter SI.MolarFlowRate p "diffusion coefficient";
  parameter SI.Concentration k "Michaelis constant";
equation
  rate = p * michaelisMenten(src.amount / vol_src, k);
annotation(
  Icon(graphics = {
    Text(origin = {5, -14}, extent = {{-3, 14}, {31, -22}}, textString = "MM")
  })
);
end DiffMM;

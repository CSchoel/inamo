within InaMo.Components.IonConcentrations;
partial model DiffusionVol "diffusion using volume fractions"
  extends Diffusion;
  SI.MolarFlowRate j "rate of change in substance amount";
equation
  src.rate + dst.rate = 0 "conservation of mass";
  src.rate = j;
end DiffusionVol;

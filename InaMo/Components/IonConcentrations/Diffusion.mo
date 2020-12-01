within InaMo.Components.IonConcentrations;
model Diffusion "simple linear diffusion with time constant"
  extends InaMo.Icons.InsideBottomOutsideTop;
  extends InactiveChemicalTransport;
  extends InaMo.Icons.Diffusion;
  parameter SI.Duration tau "time constant of diffusion";
equation
  coeff = 1 / tau;
end Diffusion;

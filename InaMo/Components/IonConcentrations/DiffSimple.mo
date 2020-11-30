within InaMo.Components.IonConcentrations;
model DiffSimple "simple linear diffusion with time constant"
  extends InactiveChemicalTransport;
  parameter SI.Duration tau "time constant of diffusion";
equation
  coeff = 1 / tau;
end DiffSimple;

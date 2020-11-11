within InaMo.Components.IonConcentrations;
model DiffSimple "simple linear diffusion with time constant"
  extends DiffusionVol;
  parameter SI.Duration tau "time constant of diffusion";
equation
  j = (src.amount - dst.amount) / tau;
end DiffSimple;

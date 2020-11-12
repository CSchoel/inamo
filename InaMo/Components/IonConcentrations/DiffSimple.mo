within InaMo.Components.IonConcentrations;
model DiffSimple "simple linear diffusion with time constant"
  extends DiffusionVol;
  parameter SI.Duration tau "time constant of diffusion";
equation
  // TODO: diffusion does not equalize substance amounts but concentrations
  // but how do we then determine what a concentration change means for the compartment?
  j = (src.amount - dst.amount) / tau;
end DiffSimple;

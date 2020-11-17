within InaMo.Components.IonConcentrations;
model DiffSimple "simple linear diffusion with time constant"
  extends DiffusionVol;
  parameter SI.Duration tau "time constant of diffusion";
equation
  j = (src.amount / vol_src - dst.amount / vol_dst) * vol_trans / tau;
end DiffSimple;

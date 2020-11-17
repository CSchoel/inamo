within InaMo.Components.IonConcentrations;
partial model DiffusionVol "diffusion using volume fractions"
  extends Diffusion;
  parameter SI.Volume vol_src "volume of source compartment";
  parameter SI.Volume vol_dst "volume of destination compartment";
  parameter SI.Volume vol_trans = min(vol_src, vol_dst)
    "volume of substance that is transferred between compartments over one second";
end DiffusionVol;

within InaMo.Components.IonConcentrations;
partial model DiffusionVol "diffusion using volume fractions"
  extends Diffusion;
  Real j(unit="mol/(m3.s)") "rate of change in concentration (~= diffusion flux)";
  parameter SI.Volume v_dst = 1 "volume of the destination compartment";
  parameter SI.Volume v_src = 1 "volume of the source compartment";
protected
  parameter SI.Volume v_min = min(v_src, v_dst);
equation
  dst.rate = -j * v_min / v_dst;
  src.rate = j * v_min / v_src;
end DiffusionVol;

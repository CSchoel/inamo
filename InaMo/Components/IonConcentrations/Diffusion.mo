within InaMo.Components.IonConcentrations;
partial model Diffusion "base model for diffusion reactions"
  extends InaMo.Icons.Diffusion;
  replaceable connector ConcentrationType = CalciumConcentration;
  ConcentrationType dst "destination of diffusion (for positive sign)"
    annotation(Placement(transformation(extent = {{-115, -15}, {-85, 15}})));
  ConcentrationType src "source of diffusion (for positive sign)"
    annotation(Placement(transformation(extent = {{85, -15}, {115, 15}})));
end Diffusion;

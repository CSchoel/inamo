within InaMo.Components.IonConcentrations;
partial model Diffusion "base model for diffusion reactions"
  extends InaMo.Icons.Diffusion;
  replaceable connector SubstanceSite = CalciumSite;
  SubstanceSite dst "destination of diffusion (for positive sign)"
    annotation(Placement(transformation(extent = {{-115, -15}, {-85, 15}})));
  SubstanceSite src "source of diffusion (for positive sign)"
    annotation(Placement(transformation(extent = {{85, -15}, {115, 15}})));
end Diffusion;

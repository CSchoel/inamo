within InaMo.Components.IonConcentrations;
model ReleaseInact "reaction of activator to inactive product"
  extends ReversibleReaction;
  parameter SI.Concentration ka "concentration producing half occupation";
  CalciumSite ca;
equation
  ca.rate = 0;
  rate = 33.96 + 339.6 * hillLangmuir(ca.c, ka, 4);
end ReleaseInact;

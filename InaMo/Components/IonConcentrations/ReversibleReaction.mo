within InaMo.Components.IonConcentrations;
model ReversibleReaction
  extends Modelica.Icons.UnderConstruction;
  replaceable connector SubstanceSite = CalciumSite;
  SubstanceSite react "reactant concentration";
  SubstanceSite prod "product concentration";
  Real rate(unit="1") "reaction rate";
equation
  react.rate = rate * prod.rate;
  prod.rate = -rate * react.rate;
end ReversibleReaction;

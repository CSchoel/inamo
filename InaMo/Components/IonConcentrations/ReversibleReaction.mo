within InaMo.Components.IonConcentrations;
model ReversibleReaction
  extends Modelica.Icons.UnderConstruction;
  replaceable connector ConcentrationType = CalciumConcentration;
  ConcentrationType react "reactant concentration";
  ConcentrationType prod "product concentration";
  Real rate(unit="1") "reaction rate";
equation
  react.rate = rate * prod.rate;
  prod.rate = -rate * react.rate;
end ReversibleReaction;

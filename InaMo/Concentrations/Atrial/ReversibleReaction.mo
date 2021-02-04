within InaMo.Concentrations.Atrial;
model ReversibleReaction
  extends Modelica.Icons.UnderConstruction;
  InaMo.Concentrations.Interfaces.SubstanceSite react "reactant concentration";
  InaMo.Concentrations.Interfaces.SubstanceSite prod "product concentration";
  Real rate(unit="1") "reaction rate";
equation
  react.rate = rate * prod.rate;
  prod.rate = -rate * react.rate;
end ReversibleReaction;

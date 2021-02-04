within InaMo.Concentrations.Atrial;
model ReversibleReaction
  extends Modelica.Icons.UnderConstruction;
  replaceable connector SubstanceSite = InaMo.Concentrations.Interfaces.CalciumSite;
  SubstanceSite react "reactant concentration";
  SubstanceSite prod "product concentration";
  Real rate(unit="1") "reaction rate";
equation
  react.rate = rate * prod.rate;
  prod.rate = -rate * react.rate;
end ReversibleReaction;

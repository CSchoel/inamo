within InaMo.Concentrations.Atrial;
model ReleaseReact "recovery of inactive product to precursor"
  extends ReversibleReaction;
  parameter Real k(unit="1") "reaction constant";
equation
  rate = k;
end ReleaseReact;

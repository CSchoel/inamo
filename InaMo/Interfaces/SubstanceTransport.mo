within InaMo.Interfaces;
partial model SubstanceTransport "base model for transport of an amount of substance between two compartments"
  replaceable connector SubstanceSite = CalciumSite;
  SubstanceSite dst "destination of transport (for positive rate)"
    annotation(Placement(transformation(extent = {{-15, 85}, {15, 115}})));
  SubstanceSite src "source of transport (for positive rate)"
    annotation(Placement(transformation(extent = {{-15, -115}, {15, -85}})));
  SI.MolarFlowRate rate "rate of change in substance amount";
equation
  src.rate + dst.rate = 0 "conservation of mass";
  src.rate = rate;
end SubstanceTransport;

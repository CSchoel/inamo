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
annotation(
  Icon(
    coordinateSystem(
      extent= {{-100,-100},{100,100}},
      preserveAspectRatio= false
    ),
    graphics= {
      Line(
        origin= {-100,2145.04},
        points= {{100.05, -2159.81}, {100.05, -2135.89}},
        thickness= 0.5
      ),
      Line(
        origin= {-100,2145.04},
        points= {{94.67, -2141.41}, {100.05, -2135.89}, {105.71, -2141.41}},
        thickness= 0.5
      )
    }
  )
);
end SubstanceTransport;

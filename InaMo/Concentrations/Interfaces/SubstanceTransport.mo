within InaMo.Concentrations.Interfaces;
partial model SubstanceTransport "base model for transport of an amount of substance between two compartments"
  SubstanceSite dst "destination of transport (for positive rate)"
    annotation(Placement(transformation(extent = {{-15, 85}, {15, 115}})));
  SubstanceSite src "source of transport (for positive rate)"
    annotation(Placement(transformation(extent = {{-15, -115}, {15, -85}})));
  SI.MolarFlowRate rate "rate of change in substance amount";
  // NOTE: due to a bug in OpenModelica, this currently has to come last
  replaceable connector SubstanceSite = CalciumSite "connector type defining the type of the substance";
equation
  src.rate + dst.rate = 0 "conservation of mass";
  src.rate = rate;
annotation(
  Documentation(info="<html>
    <p>This is a base class for models that represent a substance transfer
    from one compartment to another.</p>
    <p>If both <code>src</code> and <code>dst</code> are also connected to
    an instance of InaMo.Concentrations.Basic.Compartment, models inheriting
    from this subclass will ensure conservation of mass between these
    compartments.</p>
  </html>"),
  Icon(
    coordinateSystem(
      extent= {{-100,-100},{100,100}},
      preserveAspectRatio= false
    ),
    graphics= {
      Line(
        origin= {-100,2145.04},
        points= {{100.05, -2157.01}, {100.05, -2133.08}},
        thickness= 0.5
      ),
      Line(
        origin= {-100,2145.04},
        points= {{94.67, -2138.60}, {100.05, -2133.08}, {105.71, -2138.60}},
        thickness= 0.5
      )
    }
  )
);
end SubstanceTransport;

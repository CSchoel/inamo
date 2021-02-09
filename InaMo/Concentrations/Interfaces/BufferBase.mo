within InaMo.Concentrations.Interfaces;
partial model BufferBase "base model for buffer substances"
  extends InaMo.Icons.Buffer;
  InaMo.Concentrations.Interfaces.SubstanceSite site
    "binding site for target molecule"
    annotation(Placement(transformation(extent = {{-45, 57}, {-11, 91}})));
  parameter SI.AmountOfSubstance n_tot "total amount of buffer";
  parameter Real f_start(unit="1") "initial value for f";
  parameter Real k(unit="mol-1s-1") "association constant";
  parameter Real kb(unit="s-1") "dissociation constant";
  Real f(start=f_start, fixed=true) "fractional occupancy of buffer by Ca2+";
equation
  site.rate = n_tot * der(f);
annotation(
  Icon(
    graphics = {
      Text(
        origin = {-91, -31},
        rotation = 90,
        extent = {{-69, 21}, {133, -11}},
        textString = "%name"
      )
    }
  )
);
end BufferBase;
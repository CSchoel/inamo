within InaMo.Components.IonConcentrations;
partial model BufferBase "base model for buffer substances"
  extends InaMo.Icons.Buffer;
  replaceable connector SubstanceSite = CalciumSite;
  SubstanceSite site
    annotation(Placement(transformation(extent = {{-45, 57}, {-11, 91}})));
  parameter SI.AmountOfSubstance n_tot "total amount of buffer";
  parameter Real f_start(unit="1") "initial value for f";
  parameter Real k "association constant";
  parameter Real kb "dissociation constant";
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

within InaMo.Concentrations.Basic;
model Buffer "buffer that only binds to a single ligand"
  extends InaMo.Icons.Buffer;
  InaMo.Concentrations.Interfaces.SubstanceSite site
    "binding site for ligand"
    annotation(Placement(transformation(extent = {{-45, 57}, {-11, 91}})));
  parameter SI.AmountOfSubstance n_tot "total amount of buffer";
  parameter Real f_start(unit="1") "initial value for f";
  parameter Real k(unit="mol-1s-1") "association constant";
  parameter Real kb(unit="s-1") "dissociation constant";
  parameter SI.Volume vol = 1 "volume of compartment in which buffer resides";
  ReversibleAssociation assoc(k=k, kb=kb) annotation(Placement(transformation(origin={35,0}, extent={{-20, -20}, {20, 20}})));
  Compartment free(c_start=(1-f_start)*n_tot/vol, vol=vol) annotation(Placement(transformation(origin={24,60}, extent={{-20, -20}, {20, 20}})));
  Compartment occupied(c_start=f_start*n_tot/vol, vol=vol) annotation(Placement(transformation(origin={80,30}, extent={{-20, -20}, {20, 20}})));
equation
  connect(assoc.ligand, site) annotation(
    Line(points = {{-28, 74}, {-28, -10}, {18, -10}}));
  connect(assoc.free, free.substance) annotation(
    Line(points = {{18, 10}, {6, 10}, {6, 30}, {24, 30}, {24, 40}}));
  connect(assoc.occupied, occupied.substance) annotation(
    Line(points = {{58, 0}, {80, 0}, {80, 8}}));
annotation(
  Icon(
    graphics = {
      Text(origin = {-110,0}, extent = {{-100, -10}, {100, 10}}, textString = "%name", rotation=90)
    }
  )
);
end Buffer;

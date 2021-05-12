model Buffer2
  extends InaMo.Icons.Buffer;
  InaMo.Concentrations.Interfaces.SubstanceSite site_a "binding site for ligand A" annotation(
    Placement(transformation(extent = {{-45, 57}, {-11, 91}})));
  InaMo.Concentrations.Interfaces.SubstanceSite site_b "binding site for ligand B" annotation(
    Placement(transformation(extent = {{105, 85}, {135, 115}})));
  parameter SI.AmountOfSubstance n_tot "total amount of buffer";
  parameter Real f_a_start(unit = "1") "initial value for f";
  parameter Real f_b_start(unit = "1") "initial value for f";
  parameter Real k_a(unit = "mol-1s-1") "association constant for binding to ligand A";
  parameter Real k_b(unit = "mol-1s-1") "association constant for binding to ligand B";
  parameter Real kb_a(unit = "s-1") "dissociation constant for binding to ligand A";
  parameter Real kb_b(unit = "s-1") "dissociation constant for binding to ligand B";
  parameter SI.Volume vol = 1 "volume of compartment in which buffer resides";
  ReversibleAssociation assoc_a(k = k_a, kb = kb_a) annotation(
    Placement(transformation(origin = {-46, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  ReversibleAssociation assoc_b(k = k_b, kb = kb_b) annotation(
    Placement(transformation(origin = {46, 10}, extent = {{-10, 10}, {10, -10}})));
  Compartment free(c_start = (1 - f_a_start - f_b_start) * n_tot / vol, vol = vol) annotation(
    Placement(transformation(origin = {0, 20}, extent = {{-10, -10}, {10, 10}})));
  Compartment occupied_a(c_start = f_a_start * n_tot / vol, vol = vol) annotation(
    Placement(transformation(origin = {-90, 10}, extent = {{-10, -10}, {10, 10}})));
  Compartment occupied_b(c_start = f_b_start * n_tot / vol, vol = vol) annotation(
    Placement(transformation(origin = {90, 10}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(site_a, assoc_a.ligand) annotation(
    Line(points = {{-30, 74}, {-20, 74}, {-20, 14}, {-36, 14}}));
  connect(assoc_a.free, free.substance) annotation(
    Line(points = {{-36, 4}, {2, 4}, {2, 10}}));
  connect(occupied_a.substance, assoc_a.occupied) annotation(
    Line(points = {{-90, 0}, {-90, -8}, {-68, -8}, {-68, 10}, {-56, 10}}));
  connect(site_b, assoc_b.ligand) annotation(
    Line(points = {{105, 100}, {26, 100}, {26, 15}, {36, 15}}));
  connect(free.substance, assoc_b.free) annotation(
    Line(points = {{2, 10}, {2, 4}, {36, 4}}));
  connect(assoc_b.occupied, occupied_b.substance) annotation(
    Line(points = {{56, 10}, {70, 10}, {70, -8}, {90, -8}, {90, 0}}));
  annotation(
    Icon(graphics = {Line(origin = {94, 99}, points = {{-6, -5}, {-2, -3}, {3, -8}, {10, -11}, {16, -7}}, thickness = 0.5), Text(origin = {-110, 0}, extent = {{-100, -10}, {100, 10}}, textString = "%name", rotation = 90)}));
end Buffer2;
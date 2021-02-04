within InaMo.Concentrations.Basic;
model Buffer2
  extends InaMo.Icons.Buffer annotation(
    IconMap(extent = {{-120, -100}, {80, 100}}));
  replaceable connector SubstanceSiteA = InaMo.Concentrations.Interfaces.CalciumSite "connector type defining the type of the substance";
  replaceable connector SubstanceSiteB = InaMo.Concentrations.Interfaces.CalciumSite "connector type defining the type of the substance";
  SubstanceSiteA site_a
    "binding site for ligand A"
    annotation(Placement(transformation(extent = {{-65, 57}, {-31, 91}})));
  SubstanceSiteB site_b
    "binding site for ligand B";
    annotation(Placement(transformation(extent = {{85, 85}, {115, 115}})));
  parameter SI.AmountOfSubstance n_tot "total amount of buffer";
  parameter Real f_a_start(unit="1") "initial value for f";
  parameter Real f_b_start(unit="1") "initial value for f";
  parameter Real k_a(unit="mol-1s-1") "association constant for binding to ligand A";
  parameter Real k_b(unit="mol-1s-1") "association constant for binding to ligand B";
  parameter Real kb_a(unit="s-1") "dissociation constant for binding to ligand A";
  parameter Real kb_b(unit="s-1") "dissociation constant for binding to ligand B";
  parameter SI.Volume vol = 1 "volume of compartment in which buffer resides";
  ReversibleAssociation assoc_a(k=k_a, kb=kb_a) annotation(
    Placement(transformation(origin = {-46, 10}, extent = {{-10, -10}, {10, 10}}, rotation=180)));
  ReversibleAssociation assoc_b(k=k_b, kb=kb_b) annotation(
    Placement(transformation(origin = {46, 10}, extent = {{-10, 10}, {10, -10}})));
  Compartment free(c_start=(1-f_a_start-f_b_start)*n_tot/vol, vol=vol) annotation(
    Placement(transformation(origin = {0, 20}, extent = {{-10, -10}, {10, 10}})));
  Compartment occupied_a(c_start=f_a_start*n_tot/vol, vol=vol) annotation(
    Placement(transformation(origin = {-90, 10}, extent = {{-10, -10}, {10, 10}})));
  Compartment occupied_b(c_start=f_b_start*n_tot/vol, vol=vol) annotation(
    Placement(transformation(origin = {90, 10}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(assoc_a.ligand, site_a) annotation(Line(points = {{-48, 74}, {-20, 74}, {-20, 14}, {-36, 14}}));
  connect(assoc_a.free, free.substance) annotation(Line(points = {{-36, 4}, {2, 4}, {2, 10}}));
  connect(assoc_a.occupied, occupied_a.substance) annotation(Line(points = {{-90, 0}, {-90, -8}, {-68, -8}, {-68, 10}, {-56, 10}}));
  connect(assoc_b.ligand, site_b) annotation(Line(points = {{100, 100}, {26, 100}, {26, 15}, {36, 15}}));
  connect(assoc_b.free, free.substance) annotation(Line(points = {{2, 10}, {2, 4}, {36, 4}}));
  connect(assoc_b.occupied, occupied_b.substance) annotation(Line(points = {{56, 10}, {70, 10}, {70, -8}, {90, -8}, {90, 0}}));
annotation(
  Icon(
    graphics = {
      Line(
        origin = {74, 99},
        points = {{-6, -5}, {-2, -3}, {3, -8}, {10, -11}, {16, -7}},
        thickness = 0.5
      )
    }
  )
);
end Buffer2;

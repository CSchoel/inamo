within InaMo.Concentrations.Basic;
model Buffer2p
  extends InaMo.Icons.Buffer;
  replaceable connector SubstanceSiteA = CalciumSite "connector type defining the type of the substance";
  replaceable connector SubstanceSiteB = CalciumSite "connector type defining the type of the substance";
  SubstanceSiteA site_a
    "binding site for ligand A"
    annotation(Placement(transformation(extent = {{-45, 57}, {-11, 91}})));
  SubstanceSiteB site_b
    "binding site for ligand B";
  parameter SI.AmountOfSubstance n_tot "total amount of buffer";
  parameter Real f_a_start(unit="1") "initial value for f";
  parameter Real f_b_start(unit="1") "initial value for f";
  parameter Real k_a(unit="mol-1s-1") "association constant for binding to ligand A";
  parameter Real k_b(unit="mol-1s-1") "association constant for binding to ligand B";
  parameter Real kb_a(unit="s-1") "dissociation constant for binding to ligand A";
  parameter Real kb_b(unit="s-1") "dissociation constant for binding to ligand B";
  parameter SI.Volume vol = 1 "volume of compartment in which buffer resides";
  ReversibleAssociation assoc_a(k=k_a, kb=kb_a);
  ReversibleAssociation assoc_b(k=k_b, kb=kb_b);
  Compartment free(c_start=(1-f_a_start-f_b_start)*n_tot/vol, vol=vol);
  Compartment occupied_a(c_start=f_a_start*n_tot/vol, vol=vol);
  Compartment occupied_b(c_start=f_b_start*n_tot/vol, vol=vol);
equation
  connect(assoc_a.ligand, site_a);
  connect(assoc_a.free, free.substance);
  connect(assoc_a.occupied, occupied_a.substance);
  connect(assoc_b.ligand, site_b);
  connect(assoc_b.free, free.substance);
  connect(assoc_b.occupied, occupied_b.substance);
end Buffer2p;

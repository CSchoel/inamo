within InaMo.Concentrations.Basic;
model ReversibleAssociation "reversible association reaction with stoichiometry 1:1:1"
  extends InaMo.Icons.ReversibleAssociation;
  MacromoleculeSite free "free macromolecule"
    annotation(Placement(transformation(origin= {-100,50}, extent = {{-15, -15}, {15, 15}})));
  MacromoleculeSite occupied "occupied macromolecule";
    annotation(Placement(transformation(origin= {100,0}, extent = {{-15, -15}, {15, 15}})));
  LigandSite ligand "ligand"
    annotation(Placement(transformation(origin= {-100,-50}, extent = {{-15, -15}, {15, 15}})));
  replaceable connector MacromoleculeSite = CalciumSite "connector type defining the type of the macromolecule";
  replaceable connector LigandSite = CalciumSite "connector type defining the type of the ligand";
  parameter Real k(unit="mol-1s-1") "association constant";
  parameter Real kb(unit="s-1") "dissociation constant";
protected
  SI.MolarFlowRate rate = k * ligand.amount * free.amount - kb * occupied.amount "turnover rate";
equation
  free.rate = rate;
  occupied.rate = -rate;
  ligand.rate = rate;
end ReversibleAssociation;

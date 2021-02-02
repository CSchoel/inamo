within InaMo.Concentrations.Basic;
model Association "reversible association reaction with stoichiometry 1:1:1"
  MacromoleculeSite free "free macromolecule";
  MacromoleculeSite occupied "occupied macromolecule";
  SubstanceSite ligand "ligand";
  replaceable connector MacromoleculeSite = MacromoleculeSite "connector type defining the type of the macromolecule";
  replaceable connector LigandSite = LigandSite "connector type defining the type of the ligand";
  parameter Real k(unit="mol-1s-1") "association constant";
  parameter Real kb(unit="s-1") "dissociation constant";
protected
  SI.MolarFlowRate rate = k * ligand.amount * free.amount - kb * occupied.amount "turnover rate";
equation
  free.rate = rate;
  occupied.rate = -rate;
  ligand.rate = -rate;
end Association;

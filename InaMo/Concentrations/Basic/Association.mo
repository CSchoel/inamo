within InaMo.Concentrations.Basic;
model Association "association reaction with stoichiometry 1:1:1"
  MacromoleculeSite free "free macromolecule";
  MacromoleculeSite occupied "occupied macromolecule";
  SubstanceSite ligand "ligand";
  replaceable connector MacromoleculeSite = MacromoleculeSite "connector type defining the type of the substance";
  replaceable connector LigandSite = LigandSite "connector type defining the type of the substance";
  parameter Real k(unit="mol-1s-1") "association constant";
protected
  SI.MolarFlowRate rate = k * ligand.amount * free.amount "turnover rate";
equation
  free.rate = rate;
  occupied.rate = -rate;
  ligand.rate = -rate;
end Association;

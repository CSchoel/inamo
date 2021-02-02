within InaMo.Concentrations.Basic;
model Buffer "buffer that only binds to a single ligand"
  extends InaMo.Icons.Buffer;
  replaceable connector SubstanceSite = CalciumSite "connector type defining the type of the substance";
  SubstanceSite site
    "binding site for ligand"
    annotation(Placement(transformation(extent = {{-45, 57}, {-11, 91}})));
  parameter SI.AmountOfSubstance n_tot "total amount of buffer";
  parameter Real f_start(unit="1") "initial value for f";
  parameter Real k(unit="mol-1s-1") "association constant";
  parameter Real kb(unit="s-1") "dissociation constant";
  parameter SI.Volume vol "volume of compartment in which buffer resides";
  ReversibleAssociation assoc(k=k, kb=kb);
  Compartment free(c_start=(1-f_start)*n_tot/vol, vol=vol);
  Compartment occupied(c_start=f_start*n_tot/vol, vol=vol);
equation
  connect(assoc.ligand, site);
  connect(assoc.free, free.substance);
  connect(assoc.occupied, occupied.substance);
end Buffer;

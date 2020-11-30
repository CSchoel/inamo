within InaMo.Components.IonConcentrations;
model RyanodineReceptorA
  extends RyanodineReceptor;
  Compartment rel_pre "relative amount of activator precursor in SR release compartment";
  Compartment rel_act "relative amount of activator in SR release compartment";
  Compartment rel_prod "relative amount of inactive activator product in SR release compartment";
  ReleaseAct rela;
  ReleaseInact reli;
  ReleaseReact relr;
equation
  connect(dst, rel_act.substance);
  connect(rela.react, rel_prt.substance);
  connect(rela.prod, rel_act.substance);
  connect(rela.ca, cytt.substance);
  connect(reli.react, rel_act.substance);
  connect(reli.prod, rel_prot.substance);
  connect(reli.ca, cytt.substance);
  connect(relr.react, rel_prot.substance);
  connect(relr.prod, rel_prt.substance);
end RyanodineReceptorA;

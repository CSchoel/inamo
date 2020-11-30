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
  connect(rela.react, rel_pre.substance);
  connect(rela.prod, rel_act.substance);
  connect(rela.ca, dst);
  connect(reli.react, rel_act.substance);
  connect(reli.prod, rel_prot.substance);
  connect(reli.ca, dst);
  connect(relr.react, rel_prot.substance);
  connect(relr.prod, rel_pre.substance);
end RyanodineReceptorA;

within InaMo.Components.IonConcentrations;
model CaHandlingA "Ca handling in Lindblad 1996"
  extends Modelica.Icons.UnderConstruction;
  function adjust_to_vmin "if v_min changes, x should remain proportional to v_min"
    input Real x_pres "prescribed value for parameter";
    input SI.Volume v_min_ref "reference value of v_min used along x";
    input SI.Volume v_min "current value for v_min";
    output Real x_adj "adjusted x";
  algorithm
    x_adj := x_pres * v_min_ref / v_min;
  end adjust_to_vmin;
  outer parameter SI.Volume v_cyto, v_nsr, v_jsr;
  input SI.Current v_m;
  ConstantConcentration mg(c_const=2.5) "Mg2+ concentration";
  Compartment cyto(vol=v_cyto) "Ca2+ in cytosol";
  Compartment jsr(vol=v_jsr) "Ca2+ in JSR";
  Compartment nsr(vol=v_nsr) "Ca2+ in NSR";
  Compartment rel_pre "relative amount of activator precursor in SR release compartment";
  Compartment rel_act "relative amount of activator in SR release compartment";
  Compartment rel_prod "relative amount of inactive activator product in SR release compartment";
  ReleaseAct rela(v_m=v_m);
  ReleaseInact reli;
  ReleaseReact relr;
  DiffSimple nsr_jsr(v_src=v_nsr, v_dst=v_jsr, tau=1) "translocation of Ca2+ between NSR and JSR";
  DiffHL jsr_cyto(v_src=v_jsr, v_dst=v_cyto, p=adjust_to_vmin(1, 1, v_jsr), ka=1, n=2) "release of Ca2+ from JSR into cytosol";
  DiffUptake cyto_nsr(v_src=v_cyto, v_dst=v_nsr, i_max=adjust_to_vmin(1, 1, v_nsr)) "uptake of Ca2+ from cytosol into JSR";
  Buffer cm(c_tot=0.045, k=200e3, kb=476) "calmodulin";
  Buffer tc(c_tot=0.08, k=78.4e3, kb=392) "troponin-Ca";
  Buffer2 tmc(c_tot=0.16, k=200e3, kb=6.6) "troponin-Mg binding to Ca2+";
  Buffer2 tmm(c_tot=0, k=2e3, kb=666) "troponin-Mg binding to Mg2+"; // c_tot not relevant since {Mg2+]_i is constant
  Buffer cq(c_tot=31, k=480, kb=400) "calsequestrin";
equation
  tmc.f_other = tmm.f;
  tmm.f_other = tmc.f;
  connect(nsr_jsr.src, nsr.c);
  connect(nsr_jsr.dst, jsr.c);
  connect(jsr_cyto.src, jsr.c);
  connect(jsr_cyto.dst, cyto.c);
  connect(jsr_cyto.c_hl, rel_act.c);
  connect(cyto_nsr.src, cyto.c);
  connect(cyto_nsr.dst, nsr.c);
  connect(tc.c, cyto.c);
  connect(tmc.c, cyto.c);
  connect(tmm.c, mg.c);
  connect(cm.c, cyto.c);
  connect(cq.c, jsr.c);
  connect(rela.react, rel_pre.c);
  connect(rela.prod, rel_act.c);
  connect(rela.ca, cyto.c);
  connect(reli.react, rel_act.c);
  connect(reli.prod, rel_prod.c);
  connect(reli.ca, cyto.c);
  connect(relr.react, rel_prod.c);
  connect(relr.prod, rel_pre.c);
end CaHandlingA;

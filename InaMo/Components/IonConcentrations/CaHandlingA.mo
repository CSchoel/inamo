within InaMo.Components.IonConcentrations;
model CaHandlingA "Ca handling in Lindblad 1996"
  // TODO this probably has some errors after switching from concentrations to substance amounts
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
  ConstantConcentration mg(c_const=2.5, vol=v_cyto) "Mg2+ concentration";
  Compartment cyto(vol=v_cyto) "Ca2+ in cytosol";
  Compartment jsr(vol=v_jsr) "Ca2+ in JSR";
  Compartment nsr(vol=v_nsr) "Ca2+ in NSR";
  Diffusion nsr_jsr(tau=1) "translocation of Ca2+ between NSR and JSR";
  RyanodineReceptorA jsr_cyto(vol_dst=v_cyto, p=adjust_to_vmin(1, 1, v_jsr), ka=1, n=2) "release of Ca2+ from JSR into cytosol";
  SERCAPumpA cyto_nsr(vol_src=v_cyto, vol_dst=v_nsr, i_max=adjust_to_vmin(1, 1, v_nsr)) "uptake of Ca2+ from cytosol into JSR";
  Buffer cm(n_tot=0.045*v_cyto, k=200e3, kb=476) "calmodulin";
  Buffer tc(n_tot=0.08*v_cyto, k=78.4e3, kb=392) "troponin-Ca";
  Buffer2 tmc(n_tot=0.16*v_cyto, k=200e3, kb=6.6) "troponin-Mg binding to Ca2+";
  Buffer2 tmm(n_tot=0, k=2e3, kb=666) "troponin-Mg binding to Mg2+"; // c_tot not relevant since {Mg2+]_i is constant
  Buffer cq(n_tot=31*v_jsr, k=480, kb=400) "calsequestrin";
equation
  tmc.f_other = tmm.f;
  tmm.f_other = tmc.f;
  connect(nsr_jsr.src, nsr.substance);
  connect(nsr_jsr.dst, jsr.substance);
  connect(jsr_cyto.src, jsr.substance);
  connect(jsr_cyto.dst, cyto.substance);
  connect(cyto_nsr.src, cyto.substance);
  connect(cyto_nsr.dst, nsr.substance);
  connect(tc.site, cyto.substance);
  connect(tmc.site, cyto.substance);
  connect(tmm.site, mg.substance);
  connect(cm.site, cyto.substance);
  connect(cq.site, jsr.substance);
end CaHandlingA;

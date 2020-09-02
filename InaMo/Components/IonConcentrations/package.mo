within InaMo.Components;
package IonConcentrations
  extends Modelica.Icons.VariantsPackage;
  import InaMo.Components.Functions.*;
  import InaMo.Components.Connectors.*;
  model ConstantConcentration "ion concentration with constant value"
    replaceable connector ConcentrationType = CalciumConcentration;
    ConcentrationType c;
    parameter SI.Concentration c_const = 1 "fixed concentration";
  equation
    c.c = c_const;
  end ConstantConcentration;
  model Compartment "compartment that has an ion concentration"
    extends InaMo.Icons.Compartment;
    replaceable connector ConcentrationType = CalciumConcentration;
    ConcentrationType c;
    parameter SI.Volume vol "volume of the compartment";
    parameter SI.Concentration c_start = 1 "initial value of concentration";
  initial equation
    c.c = c_start;
  equation
    der(c.c) = c.rate;
  end Compartment;
  partial model Diffusion "base model for diffusion reactions"
    extends InaMo.Icons.Diffusion;
    replaceable connector ConcentrationType = CalciumConcentration;
    ConcentrationType dst "destination of diffusion (for positive sign)";
    ConcentrationType src "source of diffusion (for positive sign)";
  end Diffusion;
  partial model DiffusionVol "diffusion using volume fractions"
    extends Diffusion;
    Real j(unit="mol/(m3.s)") "rate of change in concentration (~= diffusion flux)";
    parameter SI.Volume v_dst = 1 "volume of the destination compartment";
    parameter SI.Volume v_src = 1 "volume of the source compartment";
  protected
    parameter SI.Volume v_min = min(v_src, v_dst);
  equation
    dst.rate = -j * v_min / v_dst;
    src.rate = j * v_min / v_src;
  end DiffusionVol;
  model DiffSimple "simple linear diffusion with time constant"
    extends DiffusionVol;
    parameter SI.Duration tau "time constant of diffusion";
  equation
    j = (src.c - dst.c) / tau;
  end DiffSimple;
  model DiffHL "diffusion following Hill-Langmuir kinetics"
    extends DiffusionVol;
    replaceable connector ConcentrationType = CalciumConcentration;
    ConcentrationType c_hl;
    parameter Real p(unit="1/s") "rate coefficient (inverse of time constant)";
    parameter SI.Concentration ka "concentration producing half occupation";
    parameter Real n(unit="1") "Hill coefficient";
  equation
    j = (src.c - dst.c) * p * hillLangmuir(c_hl.c, ka, n);
    c_hl.rate = 0;
  end DiffHL;
  model DiffMM "diffusion following Michaelis-Menten kinetics"
    extends DiffusionVol;
    parameter Real p(unit="mol/(m3.s)") "diffusion coefficient";
    parameter SI.Concentration k "Michaelis constant";
  equation
    j = p * michaelisMenten(src.c, k);
  end DiffMM;
  partial model BufferBase "base model for buffer substances"
    extends InaMo.Icons.Buffer;
    replaceable connector ConcentrationType = CalciumConcentration;
    ConcentrationType c;
    parameter SI.Concentration c_tot "total concentration of buffer";
    parameter Real f_start(unit="1") "initial value for f";
    parameter Real k "association constant";
    parameter Real kb "dissociation constant";
    Real f(start=f_start, fixed=true) "fractional occupancy of buffer by Ca2+";
  equation
    c.rate = c_tot * der(f);
  end BufferBase;
  model Buffer "buffer with a single target"
    extends BufferBase;
  equation
    der(f) = k * c.c * (1 - f) - kb * f;
  end Buffer;
  model Buffer2 "buffer that can bind to two different molecules"
    extends BufferBase;
    Real f_other(unit="1") "fractional occupancy of buffer by other molecule";
  equation
    der(f) = k * c.c * (1 - f - f_other) - kb * f;
  end Buffer2;
  model CaHandlingK "handling of Ca concentation by Kurata 2002"
    outer parameter SI.Volume v_sub, v_cyto, v_nsr, v_jsr;
    ConstantConcentration mg(c_const=2.5) "Mg2+ concentration";
    Compartment sub(vol=v_sub) "Ca2+ in subspace";
    Compartment cyto(vol=v_cyto) "Ca2+ in cytosol";
    Compartment jsr(vol=v_jsr) "Ca2+ in JSR";
    Compartment nsr(vol=v_nsr) "Ca2+ in NSR";
    DiffSimple sub_cyto(v_src=sub.vol, v_dst=cyto.vol, tau=0.04e-3)
      "diffusion from subspace to cytosol"; // tau = tau_diff,Ca
    DiffMM cyto_nsr(v_src=cyto.vol, v_dst=nsr.vol,p=0.005e3,k=0.0006)
      "diffusion from cytosol to NSR (i.e. Ca2+ uptake by SR)"; // p = P_up, k = K_up
    DiffSimple nsr_jsr(v_src=nsr.vol, v_dst=jsr.vol, tau=60e-3)
      "diffusion from NSR to JSR"; // tau = tau_tr
    DiffHL jsr_sub(v_src=jsr.vol, v_dst=sub.vol, p=5e3, ka=0.0012, n=2)
      "diffusion from JSR to subspace (i.e. Ca2+ release by SR)"; // p = P_rel, k = K_rel
    Buffer tc(c_tot=0.031, k=88.8e3, kb=0.446e3) "troponin-Ca";
    Buffer2 tmc(c_tot=0.062, k=227.7e3, kb=0.00751e3) "troponin-Mg binding to Ca2+";
    Buffer2 tmm(c_tot=0, k=2.277e3, kb=0.751e3) "troponin-Mg binding to Mg2+"; // c_tot not relevant since {Mg2+]_i is constant
    model BufferCM = Buffer(c_tot=0.045, k=227.7e3, kb=0.542e3) "base model for calmodulin";
    BufferCM cm_cyto "calmodulin in cytosol";
    BufferCM cm_sub "calmodulin in subspace";
    Buffer cq(c_tot=10, k=0.534e3, kb=0.445e3) "calsequestrin";
  equation
    tmc.f_other = tmm.f;
    tmm.f_other = tmc.f;
    connect(sub.c, sub_cyto.src);
    connect(cyto.c, sub_cyto.dst);
    connect(cyto.c, cyto_nsr.src);
    connect(nsr.c, cyto_nsr.dst);
    connect(nsr.c, nsr_jsr.src);
    connect(jsr.c, nsr_jsr.dst);
    connect(jsr.c, jsr_sub.src);
    connect(sub.c, jsr_sub.dst);
    connect(jsr_sub.c_hl, sub.c);
    connect(tc.c, cyto.c);
    connect(tmc.c, cyto.c);
    connect(tmm.c, mg.c);
    connect(cm_cyto.c, cyto.c);
    connect(cm_sub.c, sub.c);
    connect(cq.c, jsr.c);
  end CaHandlingK;
  model CaHandling "extension of Ca handling by Inaada 2009"
    extends CaHandlingK;
    // NOTE: no value is given for cm_sl.c_tot in Inada 2009 (SL_tot)
    //       => value taken from code (av_node_2.cpp:508)
    // NOTE: cm_sl.c is reduced by a factor of 1/1000 in CellML w.r.t. C++
    //       this seems like a mistake since it would render the influence
    //       of cm_sl negligible
    // NOTE: cm_sl.c of the C++ model is by an order of magnitude higher than
    //       total concentration of other buffers and cm_sl.k and cm_sl.kb are
    //       an order of magnitude lower => we multiply c_tot by 1/1000 and
    //       k and kb by 1000
    Buffer cm_sl(c_tot=0.031/1.2, k=0.115e3, kb=1e3) "calmodulin in sarcolemma";
  equation
    connect(cm_sl.c, sub.c);
  end CaHandling;

  model DiffUptake "Ca2+ uptake by SR, see Hilgeman 1987"
    extends DiffusionVol;
    parameter Real k_ca_cyto "rate constant for Ca2+ binding of calcium ATPase in cytosol";
    parameter Real k_ca_sr "rate constant for Ca2+ binding of calcium ATPase in SR";
    parameter Real k_tr_empty "rate constant for translocation of empty calcium ATPase from cytosol to SR";
    parameter SI.Current i_max "maximum uptake current";
  protected
    SI.Current i;
  equation
    i = i_max * (src.c / k_ca_cyto - k_tr_empty ^ 2 * dst.c / k_ca_sr)
      / (src.c + k_ca_cyto) / k_ca_cyto + k_tr_empty * (dst.c + k_ca_sr) / k_ca_sr;
    j = i / (2 * Modelica.Constants.F * v_min);
  end DiffUptake;
  model ReversibleReaction
    replaceable connector ConcentrationType = CalciumConcentration;
    ConcentrationType react "reactant concentration";
    ConcentrationType prod "product concentration";
    Real rate(unit="1") "reaction rate";
  equation
    react.rate = rate * prod.rate;
    prod.rate = -rate * react.rate;
  end ReversibleReaction;
  model ReleaseAct "reaction of precursor to activator"
    import InaMo.Components.Functions.Fitting.scaledExpFit;
    extends ReversibleReaction;
    CalciumConcentration ca;
    parameter SI.Concentration ka "concentration producing half occupation";
    input SI.Current v_m;
  equation
    rate = 203.8 * hillLangmuir(ca.c, ka, 4) + scaledExpFit(v_m, x0=40e-3, sx=1000/12.5, sy=203.8);
    ca.rate = 0;
  end ReleaseAct;
  model ReleaseInact "reaction of activator to inactive product"
    extends ReversibleReaction;
    parameter SI.Concentration ka "concentration producing half occupation";
    CalciumConcentration ca;
  equation
    ca.rate = 0;
    rate = 33.96 + 339.6 * hillLangmuir(ca.c, ka, 4);
  end ReleaseInact;
  model ReleaseReact "recovery of inactive product to precursor"
    extends ReversibleReaction;
    parameter Real k(unit="1") "reaction constant";
  equation
    rate = k;
  end ReleaseReact;
  model CaHandlingA "Ca handling in Lindblad 1996"
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

  model IonFlux
    replaceable connector ConcentrationType = CalciumConcentration;
    ConcentrationType ion "ion whose concentration changes";
    outer SI.Current i_ion "current responsible for moving ions";
    parameter SI.Volume vol "volume of compartment";
    parameter Real n "soichiometric ratio of ion transport";
    parameter Integer z "valence of ion";
  equation
    ion.rate = n * i_ion / (z * vol * Modelica.Constants.F);
  end IonFlux;

  model NaFlux
    SodiumConcentration na;
    parameter SI.Volume vol_na;
    parameter Real n_na = 1;
    IonFlux flux_na(
      redeclare connector ConcentrationType = SodiumConcentration,
      vol=vol_na, n=n_na, z=1
    );
  equation
    connect(na, flux_na.ion);
  end NaFlux;

  model KFlux
    PotassiumConcentration k;
    parameter SI.Volume vol_k;
    parameter Real n_k = 1;
    IonFlux flux_k(
      redeclare connector ConcentrationType = PotassiumConcentration,
      vol=vol_k, n=n_k, z=1
    );
  equation
    connect(k, flux_k.ion);
  end KFlux;

  model CaFlux
    CalciumConcentration ca;
    parameter SI.Volume vol_ca;
    parameter Real n_ca = 1;
    IonFlux flux_ca(
      redeclare connector ConcentrationType = CalciumConcentration,
      vol=vol_ca, n=n_ca, z=2
    );
  equation
    connect(ca, flux_ca.ion);
  end CaFlux;
end IonConcentrations;

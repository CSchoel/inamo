within InaMo.Components;
package IonConcentrations
  import InaMo.Components.Functions.*;
  model Compartment
    IonConcentration c;
    parameter SI.Concentration c_start = 1;
  initial equation
    c.c = c_start;
  equation
    der(c.c) = c.rate;
  end Compartment;
  partial model Diffusion
    IonConcentration pos;
    IonConcentration neg;
    Real j = 1;
    parameter Real V_pos = 1;
    parameter Real V_neg = 1;
    parameter Boolean flip = false;
  equation
    if flip then
      pos.rate = -j * V_neg / V_pos;
      neg.rate = j;
    else
      pos.rate = -j;
      neg.rate = j * V_pos / V_neg;
    end if;
  end Diffusion;
  model DiffSimple
    extends Diffusion;
    parameter SI.Duration tau;
  equation
    j = (pos.c - neg.c) / tau;
  end DiffSimple;
  model DiffMM2
    extends Diffusion;
    parameter Real p;
    parameter Real k;
  equation
    // TODO does this have something to do with MM, or is it just arbitrary?
    j = (pos.c - neg.c) * p / (1 + (k / neg.c)^2);
  end DiffMM2;
  model DiffMM
    extends Diffusion;
    parameter Real p;
    parameter Real k;
  equation
    j = p * michaelisMenten(neg.c, k);
  end DiffMM;
  model Buffer
    IonConcentration c;
    parameter SI.Concentration c_tot;
    parameter Real k;
    parameter Real kb;
    Real f;
  equation
    c.rate = c_tot * f;
    der(f) = k * c.c * (1 - f) - kb * f;
  end Buffer;
  model Buffer2 // buffer that can bind to two proteins
    IonConcentration c;
    Real f_other;
    parameter SI.Concentration c_tot;
    parameter Real k;
    parameter Real kb;
    Real f;
  equation
    c.rate = c_tot * f;
    der(f) = k * c.c * (1 - f - f_other) - kb * f;
  end Buffer2;
  model CaHandling
    IonConcentration c_mg;
    parameter SI.Concentration mg = 1;
    Compartment c_sub;
    Compartment c_cyto;
    Compartment c_JSR;
    Compartment c_NSR;
    DiffSimple sub_cyto(flip=true);
    DiffMM cyto_NSR;
    DiffSimple NSR_JSR;
    DiffMM2 JSR_sub(flip=true);
    Buffer tc;
    Buffer2 tmc;
    Buffer2 tmm;
    Buffer cm_cyto;
    Buffer cm_sub;
    Buffer cq;
  equation
    c_mg.c = mg;
    c_mg.rate = 0;
    connect(tmc.f_other, tmm.c.c);
    connect(tmm.f_other, tmc.c.c);
    connect(c_sub.c, sub_cyto.pos);
    connect(c_cyto.c, sub_cyto.neg);
    connect(c_cyto.c, cyto_NSR.neg);
    connect(c_NSR.c, cyto_NSR.pos);
    connect(c_NSR.c, NSR_JSR.neg);
    connect(c_JSR.c, NSR_JSR.pos);
    connect(c_JSR.c, JSR_sub.pos);
    connect(c_sub.c, JSR_sub.neg);
    connect(tc.c, c_cyto.c);
    connect(tmc.c, c_cyto.c);
    connect(tmm.c, c_mg);
    connect(cm_cyto.c, c_cyto.c);
    connect(cm_sub.c, c_sub.c);
    connect(cq.c, c_JSR.c);
  end CaHandling;
end IonConcentrations;

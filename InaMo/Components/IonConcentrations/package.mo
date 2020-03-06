within InaMo.Components;
package IonConcentrations
  connector IonConcentration
    SI.Concentration c;
    SI.Concentration rate;
  end IonConcentration;
  model Compartment
    IonConcentration c;
    parameter SI.Concentration c_start = 1;
  initial equation
    c.c = c_start;
  equation
    der(c.c) = c.rate;
  end Compartment;
  Compartment ex;
  model Subspace
    IonConcentration ca_ex;
    IonConcentration ca_rel;
    IonConcentration ca_in;
    IonConcentration ca_sub;
    Compartment sub;
  equation
    connect(sub.c, c_sub);
    c_sub.rate = 0;
    
  end Subspace;
end IonConcentrations;

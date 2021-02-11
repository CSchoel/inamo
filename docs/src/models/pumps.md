# Ion pumps

## Interfaces

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%nocode
%noequations
InaMo.Currents.Interfaces
```

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
InaMo.Currents.Interfaces.OnePortVertical
```

## Ion Pumps

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
InaMo.Currents.Atrioventricular.SodiumCalciumExchanger
InaMo.Currents.Atrioventricular.SodiumPotassiumPump
```

!!! note
    The SERCA pump is described in the [concentration handling](concentrations.md) section, because it is not used to influence any current but only to model the intracellular Ca2+ concentration.

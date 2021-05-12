# Ion channels

!!! note

    This documentation is work in progress.
    Currently, the extension of Documenter.jl in my package [MoST.jl](https://github.com/THM-MoTE/ModelicaScriptingTools.jl) is still experimental.
    As the package evolves further, this documentation will increase in readability.

## Interfaces

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%nocode
%noequations
%libs=Modelica@3.2.3
InaMo.Currents.Interfaces
```

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
%libs=Modelica@3.2.3
InaMo.Currents.Interfaces.TwoPinVertical
InaMo.Currents.Interfaces.TwoPinCell
InaMo.Currents.Interfaces.OnePortVertical
InaMo.Currents.Interfaces.GatedIonChannel
InaMo.Currents.Interfaces.IonChannelElectric
InaMo.Currents.Interfaces.IonChannelGHK
```

## Base classes

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
%libs=Modelica@3.2.3
InaMo.Currents.Basic.BackgroundChannel
InaMo.Currents.Basic.GateAB
InaMo.Currents.Basic.GateTS
InaMo.Currents.Basic.GateTSShift
InaMo.Currents.Basic.InstantGate
```

## Ion Channels

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
%libs=Modelica@3.2.3
InaMo.Currents.Basic.SodiumChannelBase
```

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
%libs=Modelica@3.2.3
InaMo.Currents.Atrioventricular.SodiumChannel
InaMo.Currents.Atrioventricular.RapidDelayedRectifierChannel
InaMo.Currents.Atrioventricular.LTypeCalciumChannel
InaMo.Currents.Atrioventricular.LTypeCalciumChannelN
InaMo.Currents.Atrioventricular.InwardRectifier
InaMo.Currents.Atrioventricular.TransientOutwardChannel
InaMo.Currents.Atrioventricular.HyperpolarizationActivatedChannel
InaMo.Currents.Atrioventricular.SustainedInwardChannel
InaMo.Currents.Atrioventricular.AcetylcholineSensitiveChannel
```

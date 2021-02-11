# Ion channels

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
InaMo.Currents.Interfaces.TwoPinVertical
InaMo.Currents.Interfaces.TwoPinCell
InaMo.Currents.Interfaces.OnePortVertial
InaMo.Currents.Interfaces.GatedIonChannel
InaMo.Currents.Interfaces.IonChannelElectric
InaMo.Currents.Interfaces.IonChannelGHK
```

## Base classes

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
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
InaMo.Currents.Basic.SodiumChannelBase
```

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
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

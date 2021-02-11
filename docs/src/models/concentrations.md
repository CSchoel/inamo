# Ion concentrations

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%nocode
%noequations
InaMo.Concentrations
```

## Interfaces

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
InaMo.Concentrations.Interfaces.SubstanceSite
InaMo.Concentrations.Interfaces.SubstanceTransport
InaMo.Concentrations.Interfaces.InactiveChemicalTransport
InaMo.Concentrations.Interfaces.ElectricalIonTransport
InaMo.Concentrations.Interfaces.EITransportConst
InaMo.Concentrations.Interfaces.TransmembraneCaFlow
InaMo.Concentrations.Interfaces.CaConst
InaMo.Concentrations.Interfaces.NoACh
```

## Basic components

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
InaMo.Concentrations.Basic.Compartment
InaMo.Concentrations.Basic.ConstantConcentration
InaMo.Concentrations.Basic.Diffusion
InaMo.Concentrations.Basic.ReversibleAssociation
InaMo.Concentrations.Basic.Buffer
InaMo.Concentrations.Basic.Buffer2
InaMo.Concentrations.Basic.ECAdapter
```

## Ca2+ handling

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%nocode
%noequations
InaMo.Concentrations.Atrioventricular.RyanodineReceptor
InaMo.Concentrations.Atrioventricular.SERCAPump
InaMo.Concentrations.Atrioventricular.CaHandlingK
InaMo.Concentrations.Atrioventricular.CaHandling
```

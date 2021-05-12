# Examples (full runnable models)

!!! note

    This documentation is work in progress.
    Currently, the extension of Documenter.jl in my package [MoST.jl](https://github.com/THM-MoTE/ModelicaScriptingTools.jl) is still experimental.
    As the package evolves further, this documentation will increase in readability.

## Interfaces

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
%libs=Modelica@3.2.3
InaMo.Examples.Interfaces.IVBase
```

## Full cell examples

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%libs=Modelica@3.2.3
InaMo.Examples.FullCell.FullCellCurrentPulses
InaMo.Examples.FullCell.FullCellSpon
InaMo.Examples.FullCell.AllCells
InaMo.Examples.FullCell.AllCellsC
```

## Tests for Ca2+ handling

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%libs=Modelica@3.2.3
InaMo.Examples.ComponentTests.CaBuffer
InaMo.Examples.ComponentTests.CaBuffer2
InaMo.Examples.ComponentTests.CaDiffusion
InaMo.Examples.ComponentTests.CaHandlingApprox
InaMo.Examples.ComponentTests.CaRyanodineReceptor
InaMo.Examples.ComponentTests.CaSERCA
```

## Tests for ``I_f``

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%libs=Modelica@3.2.3
InaMo.Examples.ComponentTests.HyperpolarizationActivatedIV
InaMo.Examples.ComponentTests.HyperpolarizationActivatedSteady
```

## Tests for ``I_{K,1}``

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%libs=Modelica@3.2.3
InaMo.Examples.ComponentTests.InwardRectifierLin
```

## Tests for ``I_{Ca,L}``

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%libs=Modelica@3.2.3
InaMo.Examples.ComponentTests.LTypeCalciumIV
InaMo.Examples.ComponentTests.LTypeCalciumIVN
InaMo.Examples.ComponentTests.LTypeCalciumSteady
InaMo.Examples.ComponentTests.LTypeCalciumStep
```

## Tests for ``I_{K,r}``

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%libs=Modelica@3.2.3
InaMo.Examples.ComponentTests.RapidDelayedRectifierIV
InaMo.Examples.ComponentTests.RapidDelayedRectifierSteady
```

## Tests for ``I_{NaCa}``

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%libs=Modelica@3.2.3
InaMo.Examples.ComponentTests.SodiumCalciumExchangerLin
InaMo.Examples.ComponentTests.SodiumCalciumExchangerLinKurata
InaMo.Examples.ComponentTests.SodiumCalciumExchangerLinMatsuoka
InaMo.Examples.ComponentTests.SodiumCalciumExchangerRamp
InaMo.Examples.ComponentTests.SodiumCalciumExchangerRampInada
```

## Tests for ``I_{Na}``

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%libs=Modelica@3.2.3
InaMo.Examples.ComponentTests.SodiumChannelIV
InaMo.Examples.ComponentTests.SodiumChannelSteady
```

## Tests for ``I_p``

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%libs=Modelica@3.2.3
InaMo.Examples.ComponentTests.SodiumPotassiumPumpLin
```


## Tests for ``I_{st}``

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%libs=Modelica@3.2.3
InaMo.Examples.ComponentTests.SustainedInwardIV
InaMo.Examples.ComponentTests.SustainedInwardIVKurata
InaMo.Examples.ComponentTests.SustainedInwardSteady
```

## Tests for ``I_{to}``

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%libs=Modelica@3.2.3
InaMo.Examples.ComponentTests.TransientOutwardIV
InaMo.Examples.ComponentTests.TransientOutwardSteady
```

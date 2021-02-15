# Full cell models

!!! note

    This documentation is work in progress.
    Currently, the extension of Documenter.jl in my package [MoST.jl](https://github.com/THM-MoTE/ModelicaScriptingTools.jl) is still experimental.
    As the package evolves further, this documentation will increase in readability.

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%nocode
%noequations
InaMo.Cells
```

## Base classes (Interfaces)

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%nocode
%noequations
InaMo.Cells.Interfaces
```

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%noequations
InaMo.Cells.Interfaces.CellBase
InaMo.Cells.Interfaces.ANCellBase
InaMo.Cells.Interfaces.NCellBase
InaMo.Cells.Interfaces.NHCellBase
```
## Constant intracellular Ca2+ concentration (ConstantCa)

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%nocode
%noequations
InaMo.Cells.ConstantCa
```

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
InaMo.Cells.ConstantCa.ANCellConst
InaMo.Cells.ConstantCa.NCellConst
InaMo.Cells.ConstantCa.NHCellConst
```

## Variable intracellular Ca2+ concentration (VariableCa)

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
%nocode
%noequations
InaMo.Cells.VariableCa
```

```@modelica
%outdir=out
%omcargs=-d=newInst,nfAPI
InaMo.Cells.VariableCa.ANCell
InaMo.Cells.VariableCa.NCell
InaMo.Cells.VariableCa.NHCell
```

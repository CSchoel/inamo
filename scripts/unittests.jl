using Base.Filesystem
using Test
using ModelicaScriptingTools: withOMC, testmodel
using OMJulia: sendExpression

moroot = dirname(@__DIR__)
outdir = joinpath(moroot, "out")
if !ispath(outdir)
    mkdir(outdir)
end
refdir = joinpath(moroot, "regRefData")

# relative tolerance for unit tests
# This is chosen a little larger than the tolerance used for most simulations
# (1e-6) to allow for some error propagation.
# Models that do not have a controlled timing of AP events (namely experiments
# including the N cell model) may still fail tests after small and harmless
# changes, because the error accumulates over time.
rrtol = 1e-5
withOMC(outdir, moroot) do omc
    sendExpression(omc, "setCommandLineOptions(\"-d=newInst,nfAPI\")")
    @testset "Simulate examples" begin
        @testset "SodiumChannelSteady" begin
            testmodel(omc, "InaMo.Examples.SodiumChannelSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SodiumChannelIV" begin
            testmodel(omc, "InaMo.Examples.SodiumChannelIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "InwardRectifierLin" begin
            testmodel(omc, "InaMo.Examples.InwardRectifierLin"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "GHKFlux" begin
            testmodel(omc, "InaMo.Examples.GHKFlux"; override=Dict(
                "stopTime"=>100, "numberOfIntervals"=>1000
            ), refdir=refdir, regRelTol=rrtol)
        end
        @testset "LTypeCalciumSteady" begin
            testmodel(omc, "InaMo.Examples.LTypeCalciumSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "LTypeCalciumIV" begin
            testmodel(omc, "InaMo.Examples.LTypeCalciumIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "LTypeCalciumIVN" begin
            testmodel(omc, "InaMo.Examples.LTypeCalciumIVN"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "LTypeCalciumStep" begin
            testmodel(omc, "InaMo.Examples.LTypeCalciumStep"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "TransientOutwardSteady" begin
            testmodel(omc, "InaMo.Examples.TransientOutwardSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "TransientOutwardIV" begin
            testmodel(omc, "InaMo.Examples.TransientOutwardIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "RapidDelayedRectifierSteady" begin
            testmodel(omc, "InaMo.Examples.RapidDelayedRectifierSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "RapidDelayedRectifierIV" begin
            testmodel(omc, "InaMo.Examples.RapidDelayedRectifierIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "HyperpolarizationActivatedSteady" begin
            testmodel(omc, "InaMo.Examples.HyperpolarizationActivatedSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "HyperpolarizationActivatedIV" begin
            testmodel(omc, "InaMo.Examples.HyperpolarizationActivatedIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SustainedInwardSteady" begin
            testmodel(omc, "InaMo.Examples.SustainedInwardSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SustainedInwardIV" begin
            testmodel(omc, "InaMo.Examples.SustainedInwardIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SustainedInwardIVKurata" begin
            testmodel(omc, "InaMo.Examples.SustainedInwardIVKurata"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SodiumPotassiumPumpLin" begin
            testmodel(omc, "InaMo.Examples.SodiumPotassiumPumpLin"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SodiumCalciumExchangerRampInada" begin
            testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerRampInada"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SodiumCalciumExchangerLinMatsuoka" begin
            testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerLinMatsuoka"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SodiumCalciumExchangerLinKurata" begin
            testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerLinKurata"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "AllCells" begin
            # we use a different tolerance here, because errors in N cell model accumulate over time
            testmodel(omc, "InaMo.Examples.AllCells"; refdir=refdir, regRelTol=1e-3)
        end
        @testset "AllCellsC" begin
            testmodel(omc, "InaMo.Examples.AllCellsC"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "FullCellSpon" begin
            testmodel(omc, "InaMo.Examples.FullCellSpon"; override=Dict(
                "stopTime"=>0.5, "numberOfIntervals"=>5000, "variableFilter"=>raw"cell\.(naca|cal)\.i",
                "tolerance"=>1e-6
            ), refdir=refdir, regRelTol=rrtol)
        end
        @testset "CaHandlingApprox" begin
            testmodel(omc, "InaMo.Examples.CaHandlingApprox"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "CaBuffer" begin
            testmodel(omc, "InaMo.Examples.CaBuffer"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "CaBuffer2" begin
            testmodel(omc, "InaMo.Examples.CaBuffer2"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "CaDiffusion" begin
            testmodel(omc, "InaMo.Examples.CaDiffusion"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "CaSERCA" begin
            testmodel(omc, "InaMo.Examples.CaSERCA"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "CaRyanodineReceptor" begin
            testmodel(omc, "InaMo.Examples.CaRyanodineReceptor"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "AtrialCellSmokeTest" begin
            testmodel(omc, "InaMo.Examples.AtrialCellSmokeTest"; refdir=refdir, regRelTol=rrtol)
        end
    end
end

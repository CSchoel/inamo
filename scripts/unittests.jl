using Base.Filesystem
using Test
using ModelicaScriptingTools: withOMC, testmodel, loadModel
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
            testmodel(omc, "InaMo.Examples.ComponentTests.SodiumChannelSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SodiumChannelIV" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.SodiumChannelIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "InwardRectifierLin" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.InwardRectifierLin"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "GHKFlux" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.GHKFlux"; override=Dict(
                "stopTime"=>100, "numberOfIntervals"=>1000
            ), refdir=refdir, regRelTol=rrtol)
        end
        @testset "LTypeCalciumSteady" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.LTypeCalciumSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "LTypeCalciumIV" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.LTypeCalciumIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "LTypeCalciumIVN" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.LTypeCalciumIVN"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "LTypeCalciumStep" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.LTypeCalciumStep"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "TransientOutwardSteady" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.TransientOutwardSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "TransientOutwardIV" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.TransientOutwardIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "RapidDelayedRectifierSteady" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.RapidDelayedRectifierSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "RapidDelayedRectifierIV" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.RapidDelayedRectifierIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "HyperpolarizationActivatedSteady" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.HyperpolarizationActivatedSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "HyperpolarizationActivatedIV" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.HyperpolarizationActivatedIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SustainedInwardSteady" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.SustainedInwardSteady"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SustainedInwardIV" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.SustainedInwardIV"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SustainedInwardIVKurata" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.SustainedInwardIVKurata"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SodiumPotassiumPumpLin" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.SodiumPotassiumPumpLin"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SodiumCalciumExchangerRampInada" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.SodiumCalciumExchangerRampInada"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SodiumCalciumExchangerLinMatsuoka" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.SodiumCalciumExchangerLinMatsuoka"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "SodiumCalciumExchangerLinKurata" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.SodiumCalciumExchangerLinKurata"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "AllCells" begin
            # we use a different tolerance here, because errors in N cell model accumulate over time
            testmodel(omc, "InaMo.Examples.FullCell.AllCells"; refdir=refdir, regRelTol=1e-3)
        end
        @testset "AllCellsC" begin
            # we use a different tolerance here, because errors in N cell model accumulate over time
            testmodel(omc, "InaMo.Examples.FullCell.AllCellsC"; refdir=refdir, regRelTol=1e-3)
        end
        @testset "FullCellSpon" begin
            testmodel(omc, "InaMo.Examples.FullCell.FullCellSpon"; override=Dict(
                "stopTime"=>0.5, "numberOfIntervals"=>5000, "variableFilter"=>raw"cell\.(naca|cal)\.i",
                "tolerance"=>1e-6
            ), refdir=refdir, regRelTol=rrtol)
        end
        @testset "CaHandlingApprox" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.CaHandlingApprox"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "CaBuffer" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.CaBuffer"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "CaBuffer2" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.CaBuffer2"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "CaDiffusion" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.CaDiffusion"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "CaSERCA" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.CaSERCA"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "CaRyanodineReceptor" begin
            testmodel(omc, "InaMo.Examples.ComponentTests.CaRyanodineReceptor"; refdir=refdir, regRelTol=rrtol)
        end
        @testset "AtrialCellSmokeTest" begin
            # only test if model can be loaded, simulation not working yet
            @test isnothing(loadModel(omc, "InaMo.Examples.FullCell.AllCells"))
            # testmodel(omc, "InaMo.Examples.FullCell.AllCells"; refdir=refdir, regRelTol=rrtol)
        end
        #=
        @testset "SteadyStates" begin
            # only test if model can be simulated
            # TODO this currently does not work, because internal functions cannot be referenced from outside a component
            testmodel(omc, "InaMo.Examples.ComponentTests.SteadyStates"; override=Dict(
                "stopTime"=>0.01
            ), refdir=nothing, regRelTol=rrtol)
        end
        =#
    end
end

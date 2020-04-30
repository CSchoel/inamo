using OMJulia
using Base.Filesystem
using Test
include("MoST/src/julia/MoST.jl")
using .MoST

moroot = dirname(@__DIR__)
outdir = joinpath(moroot, "out")
if !ispath(outdir)
    mkdir(outdir)
end

omc = MoST.setupOMCSession(outdir, moroot)
try
    @testset "Simulate examples" begin
        @testset "SodiumChannelSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumChannelSteady")
        end
        @testset "SodiumChannelIV" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumChannelIV")
        end
        @testset "InwardRectifierLin" begin
            MoST.testmodel(omc, "InaMo.Examples.InwardRectifierLin")
        end
        @testset "GHKFlux" begin
            MoST.testmodel(omc, "InaMo.Examples.GHKFlux"; override=Dict(
                "stopTime"=>100, "numberOfIntervals"=>1000
            ))
        end
        @testset "LTypeCalciumSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.LTypeCalciumSteady")
        end
        @testset "LTypeCalciumIV" begin
            MoST.testmodel(omc, "InaMo.Examples.LTypeCalciumIV")
        end
        @testset "LTypeCalciumIVN" begin
            MoST.testmodel(omc, "InaMo.Examples.LTypeCalciumIVN")
        end
        @testset "LTypeCalciumStep" begin
            MoST.testmodel(omc, "InaMo.Examples.LTypeCalciumStep")
        end
        @testset "TransientOutwardSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.TransientOutwardSteady")
        end
        @testset "TransientOutwardIV" begin
            MoST.testmodel(omc, "InaMo.Examples.TransientOutwardIV")
        end
        @testset "RapidDelayedRectifierSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.RapidDelayedRectifierSteady")
        end
        @testset "RapidDelayedRectifierIV" begin
            MoST.testmodel(omc, "InaMo.Examples.RapidDelayedRectifierIV")
        end
        @testset "HyperpolarizationActivatedSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.HyperpolarizationActivatedSteady")
        end
        @testset "HyperpolarizationActivatedIV" begin
            MoST.testmodel(omc, "InaMo.Examples.HyperpolarizationActivatedIV")
        end
        @testset "SustainedInwardSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.SustainedInwardSteady")
        end
        @testset "SustainedInwardIV" begin
            MoST.testmodel(omc, "InaMo.Examples.SustainedInwardIV")
        end
        @testset "SustainedInwardIVKurata" begin
            MoST.testmodel(omc, "InaMo.Examples.SustainedInwardIVKurata")
        end
        @testset "SodiumPotassiumPumpLin" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumPotassiumPumpLin")
        end
        @testset "SodiumCalciumExchangerRampInada" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerRampInada")
        end
        @testset "SodiumCalciumExchangerLinMatsuoka" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerLinMatsuoka")
        end
        @testset "SodiumCalciumExchangerLinKurata" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerLinKurata")
        end
    end
finally
    MoST.closeOMCSession(omc)
end

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
refdir = joinpath(moroot, "regRefData")

omc = MoST.setupOMCSession(outdir, moroot)
try
    @testset "Simulate examples" begin
        @testset "SodiumChannelSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumChannelSteady"; refdir=refdir)
        end
        @testset "SodiumChannelIV" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumChannelIV"; refdir=refdir)
        end
        @testset "InwardRectifierLin" begin
            MoST.testmodel(omc, "InaMo.Examples.InwardRectifierLin"; refdir=refdir)
        end
        @testset "GHKFlux" begin
            MoST.testmodel(omc, "InaMo.Examples.GHKFlux"; override=Dict(
                "stopTime"=>100, "numberOfIntervals"=>1000
            ), refdir=refdir)
        end
        @testset "LTypeCalciumSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.LTypeCalciumSteady"; refdir=refdir)
        end
        @testset "LTypeCalciumIV" begin
            MoST.testmodel(omc, "InaMo.Examples.LTypeCalciumIV"; refdir=refdir)
        end
        @testset "LTypeCalciumIVN" begin
            MoST.testmodel(omc, "InaMo.Examples.LTypeCalciumIVN"; refdir=refdir)
        end
        @testset "LTypeCalciumStep" begin
            MoST.testmodel(omc, "InaMo.Examples.LTypeCalciumStep"; refdir=refdir)
        end
        @testset "TransientOutwardSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.TransientOutwardSteady"; refdir=refdir)
        end
        @testset "TransientOutwardIV" begin
            MoST.testmodel(omc, "InaMo.Examples.TransientOutwardIV"; refdir=refdir)
        end
        @testset "RapidDelayedRectifierSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.RapidDelayedRectifierSteady"; refdir=refdir)
        end
        @testset "RapidDelayedRectifierIV" begin
            MoST.testmodel(omc, "InaMo.Examples.RapidDelayedRectifierIV"; refdir=refdir)
        end
        @testset "HyperpolarizationActivatedSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.HyperpolarizationActivatedSteady"; refdir=refdir)
        end
        @testset "HyperpolarizationActivatedIV" begin
            MoST.testmodel(omc, "InaMo.Examples.HyperpolarizationActivatedIV"; refdir=refdir)
        end
        @testset "SustainedInwardSteady" begin
            MoST.testmodel(omc, "InaMo.Examples.SustainedInwardSteady"; refdir=refdir)
        end
        @testset "SustainedInwardIV" begin
            MoST.testmodel(omc, "InaMo.Examples.SustainedInwardIV"; refdir=refdir)
        end
        @testset "SustainedInwardIVKurata" begin
            MoST.testmodel(omc, "InaMo.Examples.SustainedInwardIVKurata"; refdir=refdir)
        end
        @testset "SodiumPotassiumPumpLin" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumPotassiumPumpLin"; refdir=refdir)
        end
        @testset "SodiumCalciumExchangerRampInada" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerRampInada"; refdir=refdir)
        end
        @testset "SodiumCalciumExchangerLinMatsuoka" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerLinMatsuoka"; refdir=refdir)
        end
        @testset "SodiumCalciumExchangerLinKurata" begin
            MoST.testmodel(omc, "InaMo.Examples.SodiumCalciumExchangerLinKurata"; refdir=refdir)
        end
    end
finally
    MoST.closeOMCSession(omc)
end

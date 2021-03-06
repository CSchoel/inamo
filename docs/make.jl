using Documenter
using ModelicaScriptingTools

makedocs(
    sitename = "InaMo",
    format = Documenter.HTML(),
    pages = [
        "index.md",
        "Models" => [
            "models/cells.md",
            "models/membrane.md",
            "models/channels.md",
            "models/concentrations.md",
            "models/pumps.md",
            "models/experimental-methods.md",
            "models/examples.md"
        ],
        "Modelica features" => [
            "extends.md",
            "outer.md",
            "replaceable.md",
            "acausal.md",
        ],
        "unit-tests.md",
        "ci.md",
        "reconstruction.md"
    ],
    workdir = joinpath(@__DIR__, "build")
)

deploydocs(
    repo = "github.com/CSchoel/inamo.git",
    devbranch = "main",
    versions = ["v^", "v#.#", "stable" => "v^", "dev" => "dev"]
)

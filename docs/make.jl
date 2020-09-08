using Documenter
using ModelicaScriptingTools

makedocs(
    sitename = "InaMo",
    format = Documenter.HTML()
)

deploydocs(
    repo = "github.com/CSchoel/inamo.git",
    versions = ["v^", "v#.#", "stable" => "v^"]
)

using Documenter
using ModelicaScriptingTools

makedocs(
    sitename = "InaMo",
    format = Documenter.HTML()
)

deploydocs(
    repo = "github.com/CSchoel/inamo.git",
    devbranch = "main",
    versions = ["v^", "v#.#", "stable" => "v^"]
)

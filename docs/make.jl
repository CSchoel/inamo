using Documenter
using ModelicaScriptingTools

makedocs(
    sitename = "InaMo",
    format = Documenter.HTML()
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
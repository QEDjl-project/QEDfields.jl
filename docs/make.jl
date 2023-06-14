using QEDfields
using Documenter

DocMeta.setdocmeta!(QEDfields, :DocTestSetup, :(using QEDfields); recursive=true)

makedocs(;
    modules=[QEDfields],
    authors="Uwe Hernandez Acosta <u.hernandez@hzdr.de>, Simeon Ehrig, Klaus Steiniger, Tom Jungnickel, Anton Reinhard",
    repo="https://github.com/QEDjl-project/QEDfields.jl/blob/{commit}{path}#{line}",
    sitename="QEDfields.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

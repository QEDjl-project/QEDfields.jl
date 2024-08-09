using QEDfields
using Documenter

DocMeta.setdocmeta!(QEDfields, :DocTestSetup, :(using QEDfields); recursive=true)

makedocs(;
    modules=[QEDfields],
    authors="Uwe Hernandez Acosta <u.hernandez@hzdr.de>, Simeon Ehrig, Klaus Steiniger, Tom Jungnickel, Anton Reinhard",
    repo=Documenter.Remotes.GitHub("QEDjl-project", "QEDfields.jl"),
    sitename="QEDfields.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true", edit_link="dev", assets=String[]
    ),
    pages=["Home" => "index.md"],
)
deploydocs(; repo="github.com/QEDjl-project/QEDfields.jl.git", push_preview=false)

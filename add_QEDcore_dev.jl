
@warn "This repository depends on the dev branch of QEDcore.jl\n It is NOT ready for release!"

using Pkg: Pkg
Pkg.add(; url="https://github.com/QEDjl-project/QEDcore.jl", rev="dev")

# QEDfields

[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)


:warning: This package is under construction and only contains dummy functionality for testing.

## Installation

To install the current stable version of `QEDfields.jl` you may use the standard julia package manager within the julia REPL

```julia
julia> using Pkg

# add local registry, where QEDfields is registered
julia> Pkg.Registry.add(Pkg.RegistrySpec(url="https://github.com/QEDjl-project/registry"))
# add general registry again to have it join the local registry
julia> Pkg.Registry.add(Pkg.RegistrySpec(url="https://github.com/JuliaRegistries/General"))

julia> Pkg.add("QEDfields")
```

or you use the Pkg prompt by hitting `]` within the Julia REPL and then type

```julia
# add local registry, where QEDfields is registered
(@v1.9) pkg> registry add https://github.com/QEDjl-project/registry
# add general registry again to have it join the local registry
(@v1.9) pkg> registry add https://github.com/JuliaRegistries/General

(@v1.9) pkg> add QEDfields
```

To install the locally downloaded package on Windows, change to the parent directory and type within the Pkg prompt

```julia
(@v1.9) pkg> add ./QEDfields.jl
```

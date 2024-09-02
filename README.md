# QEDfields

[![Doc Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://qedjl-project.github.io/QEDfields.jl/stable)
[![Doc Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://qedjl-project.github.io/QEDfields.jl/dev)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

## Installation

To install the current stable version of `QEDfields.jl` you may use the standard julia package manager within the julia REPL

```julia
julia> using Pkg
julia> Pkg.add("QEDfields")
```

or you use the Pkg prompt by hitting `]` within the Julia REPL and then type

```julia
(@v1.10) pkg> add QEDfields
```

To install the locally downloaded package on Windows, change to the parent directory and type within the Pkg prompt

```julia
(@v1.10) pkg> add ./QEDfields.jl
```

# Development

## Formatting

We use [JuliaFormatter.jl](https://domluna.github.io/JuliaFormatter.jl/dev/) and the [Blue style](https://github.com/invenia/BlueStyle) to format our code. The correct form of the code is checked by a CI job. To format the code manually, run the following commands:

```bash
# install dependencies
julia --project=.formatting -e 'import Pkg; Pkg.instantiate()'
# format all documents
julia --project=.formatting .formatting/format_all.jl
```

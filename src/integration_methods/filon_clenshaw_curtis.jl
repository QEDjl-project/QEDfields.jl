# taken from https://github.com/dkm2/FCCQuad.jl/blob/25d5e17a484ae213871373beccf67a99d111667a/src/FCCQuad.jl#L310C1-L311C1
const default_reltol = Dict(Float32 => 1.0e-6, Float64 => 1.0e-8, BigFloat => 1.0e-39)

## only the definition, the functionality is placed in the extension
#=
Base.@kwdef struct FilonClenshawCurtisQuadrature{T} <: QEDfields.AbstractIntegrationMethod

    T::Type=Complex{Float64}
    reltol::Real=default_reltol[real(T)]
    abstol::Real=zero(real(T))
    method::Symbol=:tone

    vectornorm=LinearAlgebra.norm
    branching::Integer=4
    maxdepth::Integer=10
    maxchirp::Integer=6
    minlog2degree::Integer=3
    localmaxlog2degree::Integer=6
    nonadaptivelog2degree::Integer=10
    globalmaxlog2degree::Integer=20
end
=#

struct FilonClenshawCurtisQuadrature{T, V} <: QEDfields.AbstractIntegrationMethod
    reltol::Real
    abstol::Real
    method::Symbol

    vectornorm::V
    branching::Integer
    maxdepth::Integer
    maxchirp::Integer
    minlog2degree::Integer
    localmaxlog2degree::Integer
    nonadaptivelog2degree::Integer
    globalmaxlog2degree::Integer

    function FilonClenshawCurtisQuadrature(;
            T::Type = Complex{Float64},
            reltol::Real = default_reltol[real(T)],
            abstol::Real = zero(real(T)),
            method::Symbol = :tone,
            vectornorm = LinearAlgebra.norm,
            branching::Integer = 4,
            maxdepth::Integer = 10,
            maxchirp::Integer = 6,
            minlog2degree::Integer = 3,
            localmaxlog2degree::Integer = 6,
            nonadaptivelog2degree::Integer = 10,
            globalmaxlog2degree::Integer = 20,
        )
        return new{T, typeof(vectornorm)}(
            reltol,
            abstol,
            method,
            vectornorm,
            branching,
            maxdepth,
            maxchirp,
            minlog2degree,
            localmaxlog2degree,
            nonadaptivelog2degree,
            globalmaxlog2degree,
        )
    end
end

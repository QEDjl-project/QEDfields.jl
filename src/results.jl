"""
   InternalIntegralResult

Result of computing the internal integral I(phi, beta1, beta2)
- value: the computed integral value
- error: error estimate (Nothing if not available)
"""
struct InternalIntegralResult{T <: Real}
    value::T
    error::T
end

# Constructor for cases without error estimate
InternalIntegralResult(value::T) where {T} = InternalIntegralResult(value, T(NaN))

function Base.isapprox(res1::InternalIntegralResult, res2::InternalIntegralResult, kwargs...)
    return isapprox(res1.value, res2.value, kwargs...)
end
"""
    InternalIntegrals

Stores the values of internal integrals.

For definite polarization:

```math
I_1 = \\int_0^x f(y)\\,\\mathrm{d}y\\\\
I_2 = \\int_0^x f^2(y)\\,\\mathrm{d}y
```

For indefinite polarization:

```math

I_11 = \\int_0^x f_x(y)\\,\\mathrm{d}y\\\\
I_12 = \\int_0^x f_y(y)\\,\\mathrm{d}y\\\\
I_2 = \\int_0^x f_x^2(y)+ f_y^2(y)\\,\\mathrm{d}y
```
"""
struct InternalIntegrals{T <: Real, N}
    data::NTuple{N, InternalIntegralResult{T}}
    function InternalIntegrals(
            data::NTuple{N, TT}
        ) where {
            N,
            T <: Real,
            TT <: InternalIntegralResult{T},
        }
        return new{T, N}(data)
    end
end

InternalIntegrals(data::TT...) where {TT <: InternalIntegralResult} = InternalIntegrals(data)
function InternalIntegrals(data::T...) where {T <: Real}
    return InternalIntegrals(
        InternalIntegralResult.(data)...
    )
end

Base.getproperty(ii::InternalIntegrals, s::Symbol) = getproperty(ii, Val(s))
Base.getproperty(ii::InternalIntegrals, name::Val{T}) where {T} = getfield(ii, T)

Base.getproperty(ii::InternalIntegrals{T, 2}, ::Val{:I1}) where {T} = @inline ii.data[1]
Base.getproperty(ii::InternalIntegrals{T, 2}, ::Val{:I2}) where {T} = @inline ii.data[2]

Base.getproperty(ii::InternalIntegrals{T, 3}, ::Val{:I11}) where {T} = @inline ii.data[1]
Base.getproperty(ii::InternalIntegrals{T, 3}, ::Val{:I12}) where {T} = @inline ii.data[2]
Base.getproperty(ii::InternalIntegrals{T, 3}, ::Val{:I2}) where {T} = @inline ii.data[3]


"""
    PhaseIntegralResult

Result of computing the phase integral B(pnum,beta1,beta2).
- value: the computed integral value
- error: error estimate (Nothing if not available)
"""
struct PhaseIntegralResult{T <: Real}
    value::T
    error::T
end

# Constructor for cases without error estimate
PhaseIntegralResult(value::T) where {T} = PhaseIntegralResult(value, T(NaN))

function Base.isapprox(res1::PhaseIntegralResult, res2::PhaseIntegralResult, kwargs...)
    return isapprox(res1.value, res2.value, kwargs...)
end

"""

    PhaseIntegrals

Stores the results of phase integrals.
"""
struct PhaseIntegrals{T <: Real, N}
    data::NTuple{N, PhaseIntegralResult{T}}

    function PhaseIntegrals(
            data::NTuple{N, TT}
        ) where {
            N,
            T <: Real,
            TT <: PhaseIntegralResult{T},
        }
        return new{T, N}(data)
    end
end

PhaseIntegrals(data::TT...) where {TT <: PhaseIntegralResult} = PhaseIntegrals(data)
function PhaseIntegrals(data::T...) where {T <: Real}
    return PhaseIntegrals(
        PhaseIntegralResult.(data)...
    )
end

Base.getproperty(ph_int::PhaseIntegrals, s::Symbol) = getproperty(ph_int, Val(s))
Base.getproperty(ph_int::PhaseIntegrals, name::Val{T}) where {T} = getfield(ph_int, T)

Base.getproperty(ph_int::PhaseIntegrals{T, 2}, ::Val{:B1}) where {T} = @inline ph_int.data[1]
Base.getproperty(ph_int::PhaseIntegrals{T, 2}, ::Val{:B2}) where {T} = @inline ph_int.data[2]

Base.getproperty(ph_int::PhaseIntegrals{T, 3}, ::Val{:B11}) where {T} = @inline ph_int.data[1]
Base.getproperty(ph_int::PhaseIntegrals{T, 3}, ::Val{:B12}) where {T} = @inline ph_int.data[2]
Base.getproperty(ph_int::PhaseIntegrals{T, 3}, ::Val{:B2}) where {T} = @inline ph_int.data[3]

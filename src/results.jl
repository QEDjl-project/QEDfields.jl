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
    data::NTuple{N, T}
    InternalIntegrals(data::NTuple{N, T}) where {N, T <: Real} = new{T, N}(data)
end

InternalIntegrals(data::T...) where {T <: Real} = InternalIntegrals(data)

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

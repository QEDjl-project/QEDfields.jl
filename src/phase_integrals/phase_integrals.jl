###########################################
# Definitions common to all phase integrals
###########################################

# PPW field integral
@inline function _field_integral(
    field::AbstractPulsedPlaneWaveField,
    pol::AbstractPolarization,
    phi::T
) where {T<:Real}
    return
end

# PPW field squared integral
@inline function _field_squared_integral(
    field::AbstractPulsedPlaneWaveField,
    pol::AbstractPolarization,
    phi::T
) where {T<:Real}
    return
end

# kinematic vector factor alpha_1^mu appearing in Volkov phase
@inline function _kinematic_vector_phase_factor(
    field::AbstractPulsedPlaneWaveField,
    p_in::T,
    p_out::T,
) where {T<:Real}
    return
end

# kinematic scalar factor alpha_2 appearing in Volkov phase
@inline function _kinematic_scalar_phase_factor(
    field::AbstractPulsedPlaneWaveField,
    p_in::T,
    p_out::T,
) where {T<:Real}
    return
end

# non-linear Volkov phase
@inline function _phase_function(
    field::AbstractPulsedPlaneWaveField,
    pol::AbstractPolarization,
    p_in::T,
    p_out::T,
    phi::T
) where {T<:Real}
    return
end

# integrand shared by all phase integrals
@inline function _shared_integrand(
    field::AbstractPulsedPlaneWaveField,
    pol::AbstractPolarization,
    p_in::T,
    p_out::T,
    phi::T,
    pnum::T
) where {T<:Real}
    return exp(1im*(pnum*phi + _phase_function(field, pol, p_in, p_out, phi)))
end


include("zeroth_integral.jl")
include("first_integral.jl")
include("second_integral.jl")

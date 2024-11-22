###########################################
# Definitions common to all phase integrals
###########################################

# from QEDprocesses.jl/src/constants.jl
# TODO: we might want to move the constants.jl file to QEDbase? See also TODO in QEDprocesses.jl/src/processes/one_photon_compton/perturbative/cross_section.jl
const ALPHA = inv(137.035999074)
const ELEMENTARY_CHARGE = sqrt(4 * pi * ALPHA)
const ELEMENTARY_CHARGE_SQUARE = 4 * pi * ALPHA

# definite integral of PPW field
# TODO: Why does integration always start at 0?
@inline function _field_integral(
    field::AbstractPulsedPlaneWaveField,
    pol::AbstractPolarization,
    phi::T
) where {T<:Real}
    return quadgk(t -> amplitude(field, pol, t), 0.0, phi)[1]
end

# definite integral of squared PPW field
# TODO: Why does integration always start at 0?
@inline function _field_squared_integral(
    field::AbstractPulsedPlaneWaveField,
    pol::AbstractPolarization,
    phi::T
) where {T<:Real}
    return quadgk(t -> amplitude(field, pol, t)^2, 0.0, phi)[1]
end

# kinematic vector factor alpha_1^mu appearing in Volkov phase
# TODO: Is `ELEMENTARY_CHARGE` actually related to the scattering particle or just a factor
@inline function _kinematic_vector_phase_factor(
    field::AbstractPulsedPlaneWaveField,
    p_in::MT,
    p_out::MT,
) where {MT<:AbstractFourMomentum}
    k_mu = momentum(field)
    return ELEMENTARY_CHARGE*(p_out/(k_mu*p_out) - p_in/(k_mu*p_in))
end

# kinematic scalar factor alpha_2 appearing in Volkov phase
# TODO: Is `ELEMENTARY_CHARGE` actually related to the scattering particle or just a factor
@inline function _kinematic_scalar_phase_factor(
    field::AbstractPulsedPlaneWaveField,
    p_in::MT,
    p_out::MT,
) where {MT<:AbstractFourMomentum}
    k_mu = momentum(field)
    return ELEMENTARY_CHARGE_SQUARE * (1/(k_mu*p_in) - 1/(k_mu*p_out))
end

# non-linear Volkov phase
@inline function _phase_function(
    field::AbstractPulsedPlaneWaveField,
    pol::AbstractPolarization,
    p_in::MT,
    p_out::MT,
    phi::T
) where {MT<:AbstractFourMomentum, T<:Real}
    first = _kinematic_vector_phase_factor(field, p_in, p_out) * _field_integral(field, pol, phi)
    second = _kinematic_scalar_phase_factor(field, p_in, p_out) * _field_squared_integral(field, pol, phi)
    return first+second
end

# integrand shared by all phase integrals
@inline function _shared_integrand(
    field::AbstractPulsedPlaneWaveField,
    pol::AbstractPolarization,
    p_in::MT,
    p_out::MT,
    phi::T,
    pnum::T
) where {MT<:AbstractFourMomentum, T<:Real}
    return exp(1im*(pnum*phi + _phase_function(field, pol, p_in, p_out, phi)))
end


include("zeroth_integral.jl")
include("first_integral.jl")
include("second_integral.jl")

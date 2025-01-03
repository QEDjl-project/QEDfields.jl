###########################################
# Definitions common to all phase integrals
###########################################

# TODO: We need to talk about the handling of field polarization!
# Since some of the quantities required in phase integral computation are four-vectors, just as the bg-field itself,
# we need to return these as four-vectors, or their components.
# However, we do not even provide the field as a four-vector, yet.
# We just return its "amplitude", which is only the oscillator times the envelope,
# not even taking the correct maximum value a_0 of the field into account. (TODO!)
#
# I think both the polarization and the maximum value of the field should be a user defined quantity,
# but then these should also be members of the field struct, shouldn't they?
# Or are these separately set in the Process?
#
# All in all, I wonder how we should treat four-vectors in QEDfields.
# The problem of missing vectorial information appears here in _field_integral(), _kinematic_vector_phase_factor(), and phase_integral_1().

# TODO: The factors and integrals should not depend on the momenta of particles
# but on the Process and Phase Space Point (the latter of which holds the momenta)
# Question: Does the process hold a reference to the background field?
#   If so, the explicit dependence on the background field should be removed to.

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
"""

    _phase_function(field::AbstractPulsedPlaneWaveField, pol::AbstractPolarization, p_in::, p_out::, phi::)

Return the phase function (or non-linear Volkov phase), for the given phase space point `p_in, p_out` and a given phase value `phi`.

!!! note "Convention"

    The non-linear Volkov phase is defined as:

    ```math
    \\begin{align*}
        G(\\varphi,p, p^\\prime)& = \\alpha_1^\\mu \\int\\limits_0^\\varphi \\mathrm{d}\\varphi^\\prime A_\\mu(\\varphi^\\prime)
            + \\alpha_2 \\int\\limits_0^\\varphi \\mathrm{d}\\varphi^\\prime A^2(\\varphi^\\prime) \\\\
    \\end{align*}
    ```
    where ``A^\\mu(\\varphi)`` is the background field, ``\\alpha_1^\\mu`` is the [`kinematic vector phase factor`](@ref), and ``\\alpha_2`` is the [`kinematic scalar phase factor`](@ref).
    Both ``\\alpha_1^\\mu`` and ``\\alpha_2`` depend on the given phase space point ``(p,p^\\prime)`` and the field's reference momentum ``k^\\mu`` the photon number parameter.
"""
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

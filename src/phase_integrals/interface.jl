"""

    AbstractPhaseIntegral

Abstract base type for phase integrals.

Interface functions:
- `background_field(::AbstractPhaseIntegral)::AbstractBackgroundField`
- `internal_integral(::AbstractPhaseIntegral)::AbstractInternalIntegral`
- `integration_method(::AbstractPhaseIntegral)::AbstractIntegrationMethod`

Generic implementations:
- `integral_B1(::AbstractPhaseIntegral,pnum::Real, alpha1::Real, alpha2::Real)::Real`
- `integral_B1(::AbstractPhaseIntegral,pnum::Real, p::AbstractFourMomentum, p_prime::AbstractFourMomentum)::Real`
- `integral_B2(::AbstractPhaseIntegral,pnum::Real, alpha1::Real, alpha2::Real)::Real`
- `integral_B2(::AbstractPhaseIntegral,pnum::Real, p::AbstractFourMomentum, p_prime::AbstractFourMomentum)::Real`
"""
abstract type AbstractPhaseIntegral{P <: AbstractBackgroundField} end

"""

    internal_integral(::AbstractPhaseIntegral)

"""
function internal_integral end

"""

    integral_B1(
        ::AbstractPhaseIntegral,
        pnum::Real,
        alpha1::Real,
        alpha2::Real
    )

    integral_B1(
        ::AbstractPhaseIntegral,
        pnum::Real,
        p::AbstractFourMomentum,
        p_prime::AbstractFourMomentum
    )

"""
function integral_B1 end

"""

    integral_B2(
        ::AbstractPhaseIntegral,
        pnum::Real,
        alpha1::Real,
        alpha2::Real
    )

    integral_B2(
        ::AbstractPhaseIntegral,
        pnum::Real,
        p::AbstractFourMomentum,
        p_prime::AbstractFourMomentum
    )

"""
function integral_B2 end

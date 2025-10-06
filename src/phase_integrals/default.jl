### default implementation for pulsed plane-wave fields

"""

    integral_B1(::PhaseIntegral,pnum,alpha1,alpha2)

"""
function integral_B1(
        phase_integral::AbstractPhaseIntegral{P},
        pnum::Real,
        alpha1::Real,
        alpha2::Real
    ) where {
        P <: AbstractPulsedPlaneWaveField,
    }


    field = background_field(phase_integral)
    method = integration_method(phase_integral)
    internal_int = internal_integral(phase_integral)

    integrand = x -> _amplitude(field, x) * exp(1im * pnum * x + 1im * volkov_phase(internal_int, x, alpha1, alpha2))
    res = integrate(method, integrand, domain(field))

    # TODO: check prefac of amplitude
    return res
end

"""

    integral_B2(::PhaseIntegral,pnum,alpha1,alpha2)

"""
function integral_B2(
        phase_integral::AbstractPhaseIntegral{P},
        pnum::Real,
        alpha1::Real,
        alpha2::Real
    ) where {
        P <: AbstractPulsedPlaneWaveField,
    }

    field = background_field(phase_integral)
    method = integration_method(phase_integral)
    internal_int = internal_integral(phase_integral)

    integrand = x -> _amplitude(field, x)^2 * exp(1im * pnum * x + 1im * volkov_phase(internal_int, x, alpha1, alpha2))
    res = integrate(method, integrand, domain(field))

    return res
end

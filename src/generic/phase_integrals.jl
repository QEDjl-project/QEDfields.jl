# TBW

_tuple_pack(x::T) where {T <: Number} = (x,)
_tuple_pack(x::Tuple) = x

function phase_integrals(
        field::AbstractPlaneWaveField{P},
        internal_integral_method::AbstractIntegrationMethod,
        phase_integral_method::AbstractIntegrationMethod,
        pnum::Real,
        beta1::Real,
        beta2::Real
    ) where {
        P <: AbstractDefinitePolarization,
    }

    dom = domain(field)

    integrand1 = x -> _amplitude(field, x) * exp(1im * pnum * x + 1im * volkov_phase(field, x, beta1, beta2))
    integrand2 = x -> _amplitude(field, x)^2 * exp(1im * pnum * x + 1im * volkov_phase(field, x, beta1, beta2))

    res1 = integrate(method, integrand1, dom)
    res2 = integrate(method, integrand2, dom)

    # TODO: check prefac of amplitude
    return PhaseIntegralResult(_tuple_pack(res1)...), PhaseIntegralResult(_tuple_pack(res2)...)
end

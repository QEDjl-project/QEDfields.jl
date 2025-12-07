# TBW

_tuple_pack(x::Number) = (x,)
_tuple_pack(x::AbstractVector) = Tuple(x)
_tuple_pack(x::Tuple) = x

function phase_integrals(
        field::AbstractPlaneWaveField{P},
        internal_integral_method::AbstractIntegrationMethod,
        phase_integral_method::AbstractIntegrationMethod,
        pnum::T,
        beta1::T,
        beta2::T
    )::PhaseIntegrals{Complex{T}, 2} where {
        T <: Real,
        P <: AbstractDefinitePolarization,
    }

    dom = domain(field)
    max_amp = maximum_amplitude(field)

    # TODO: make max_amp factors global
    integrand1 = x -> max_amp * _amplitude(field, x) * exp(1im * pnum * x + 1im * _volkov_phase(field, internal_integral_method, x, beta1, beta2))
    integrand2 = x -> max_amp^2 * _amplitude(field, x)^2 * exp(1im * pnum * x + 1im * _volkov_phase(field, internal_integral_method, x, beta1, beta2))

    res1 = integrate(phase_integral_method, integrand1, dom)
    res2 = integrate(phase_integral_method, integrand2, dom)

    return PhaseIntegrals(
        PhaseIntegralResult(_tuple_pack(res1)...),
        PhaseIntegralResult(_tuple_pack(res2)...),
    )
end


# FIXME: This is wrong! We need to insert the xi-dependent terms
function phase_integrals(
        field::AbstractPlaneWaveField{P},
        internal_integral_method::AbstractIntegrationMethod,
        phase_integral_method::AbstractIntegrationMethod,
        pnum::Real,
        beta11::Real,
        beta12::Real,
        beta2::Real
    ) where {
        P <: AbstractIndefinitePolarization,
    }

    dom = domain(field)
    max_amp = maximum_amplitude(field)

    # TODO: make max_amp factors global
    integrand11 = x -> max_amp * _amplitude(field, PolX(), x) * exp(1im * pnum * x + 1im * _volkov_phase(field, x, beta11, beta12, beta2))
    integrand12 = x -> max_amp * _amplitude(field, PolY(), x) * exp(1im * pnum * x + 1im * _volkov_phase(field, x, beta11, beta12, beta2))
    integrand2 = x -> max_amp^2 * (_amplitude(field, PolX(), x)^2 + _amplitude(field, PolY(), x)^2) * exp(1im * pnum * x + 1im * _volkov_phase(field, x, beta11, beta12, beta2))

    res11 = integrate(method, integrand11, dom)
    res12 = integrate(method, integrand12, dom)
    res2 = integrate(method, integrand2, dom)

    return PhaseIntegrals(
        PhaseIntegralResult(_tuple_pack(res11)...),
        PhaseIntegralResult(_tuple_pack(res12)...),
        PhaseIntegralResult(_tuple_pack(res2)...),
    )
end

@inline _sinc(x) = sinc(x / pi)

@inline function _internal_integral1_cos_square(::PolX, phi, dphi)

    fac_plus = pi / dphi + 1
    fac_minus = pi / dphi - 1
    return sin(phi) / 2 + phi / 4 * (_sinc(fac_plus * phi) + _sinc(fac_minus * phi))
end

@inline function _internal_integral1_cos_square(::PolY, phi, dphi)

    fac_plus = 1 + pi / dphi
    fac_minus = 1 - pi / dphi

    return phi^2 / 4 * (
        fac_plus / 2 * _sinc(fac_plus * phi / 2)^2 + fac_minus / 2 * _sinc(fac_minus * phi / 2)^2 + _sinc(phi / 2)^2
    )
end

@inline function _internal_integral2_cos_square(::PolX, phi, dphi)
    k = pi / dphi
    term1 = phi
    term2 = sin(2 * phi) / 2
    term3 = _sinc(k * phi) / 4
    term4 = _sinc(2 * k * phi) / 8
    term5 = (_sinc((k + 2) * phi) + _sinc((k - 2) * phi)) / 2
    term6 = (_sinc((2 * k + 2) * phi) + _sinc((2 * k - 2) * phi)) / 8

    return 3 * (term1 + term2) / 16 + phi * (term3 + term4 + term5 + term6) / 4
end

@inline function _internal_integral2_cos_square(::PolY, phi, dphi)
    k = pi / dphi
    term1 = phi
    term2 = sin(2 * phi) / 2
    term3 = _sinc(k * phi) / 4
    term4 = _sinc(2 * k * phi) / 8
    term5 = (_sinc((k + 2) * phi) + _sinc((k - 2) * phi)) / 2
    term6 = (_sinc((2 * k + 2) * phi) + _sinc((2 * k - 2) * phi)) / 8

    return 3 * (term1 - term2) / 16 + phi * (term3 + term4 - term5 - term6) / 4
end

# FIXME: This is wrong! We need to insert the xi-dependent terms
@inline function _internal_integral2_cos_square(phi, dphi)
    value_I21 = _internal_integral2_cos_square(pol, phi, pulse_len)
    value_I22 = _internal_integral2_cos_square(pol, phi, pulse_len)

    return value_I21 + value_I22
end

# interface

@inline function _internal_integrals(pulse::CosSquarePulse, pol::P, method::Analytical, phi::T) where {T <: Real, P <: AbstractDefinitePolarization}

    pulse_len = pulse_length(pulse)
    value_I1 = _internal_integral1_cos_square(pol, phi, pulse_len)
    value_I2 = _internal_integral2_cos_square(pol, phi, pulse_len)

    return InternalIntegrals(
        InternalIntegralResult(value_I1, zero(value_I1)),
        InternalIntegralResult(value_I2, zero(value_I2))
    )
end

# FIXME: This is wrong! We need to insert the xi-dependent terms
@inline function _internal_integrals(pulse::CosSquarePulse, pol::P, method::Analytical, phi::T) where {T <: Real, P <: AbstractIndefinitePolarization}
    pulse_len = pulse_length(pulse)
    value_I11 = _internal_integral1_cos_square(PolX(), phi, pulse_len)
    value_I12 = _internal_integral2_cos_square(PolY(), phi, pulse_len)

    # TODO: update with xi!
    value_I2 = _internal_integral2_cos_square(phi, pulse_len)

    return InternalIntegrals(res12, res12, res2)
end

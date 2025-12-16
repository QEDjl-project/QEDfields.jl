@inline _sinc(x) = sinc(x / pi)

# solved integral_0^phi dphi' g(phi') * cos(phi)
@inline function _internal_integral1_cos_square(::PolX, phi, dphi)

    fac_plus = pi / dphi + 1
    fac_minus = pi / dphi - 1
    return sin(phi) / 2 + phi / 4 * (_sinc(fac_plus * phi) + _sinc(fac_minus * phi))
end

# solved integral_0^phi dphi' g(phi') * sin(phi)
@inline function _internal_integral1_cos_square(::PolY, phi, dphi)

    fac_plus = 1 + pi / dphi
    fac_minus = 1 - pi / dphi

    return phi^2 / 4 * (
        fac_plus / 2 * _sinc(fac_plus * phi / 2)^2 + fac_minus / 2 * _sinc(fac_minus * phi / 2)^2 + _sinc(phi / 2)^2
    )
end

# solved integral_0^phi dphi' (g(phi') * cos(phi))^2
@inline function _internal_integral2_cos_square(::PolX, phi, dphi)
    k0 = pi / dphi
    k1p = 1 + k0
    k1m = 1 - k0
    k2p = 2 + k0
    k2m = 2 - k0

    res = 3 * phi
    res += 4 * sin(k0 * phi) / k0
    res += sin(2 * k0 * phi) / (2 * k0)
    res += 3 * sin(2 * phi) / 2
    res += phi * _sinc(2 * k1m * phi) / 2
    res += phi * _sinc(2 * k1p * phi) / 2
    res += 2 * phi * _sinc(k2m * phi)
    res += 2 * phi * _sinc(k2p * phi)
    return res / 16
end

# solved integral_0^phi dphi' (g(phi') * sin(phi))^2
@inline function _internal_integral2_cos_square(::PolY, phi, dphi)
    k0 = pi / dphi
    k1p = 1 + k0
    k1m = 1 - k0
    k2p = 2 + k0
    k2m = 2 - k0

    res = 3 * phi
    res += 4 * sin(k0 * phi) / k0
    res += sin(2 * k0 * phi) / (2 * k0)
    res -= 3 * sin(2 * phi) / 2
    res -= phi * _sinc(2 * k1m * phi) / 2
    res -= phi * _sinc(2 * k1p * phi) / 2
    res -= 2 * phi * _sinc(k2m * phi)
    res -= 2 * phi * _sinc(k2p * phi)
    return res / 16
end

@inline function _internal_integral2_cos_square(phi, dphi, xi)
    value_I21 = oscillator(PolX(), pol.xi)^2 * _internal_integral2_cos_square(pol, phi, pulse_len)
    value_I22 = oscillator(PolY(), pol.xi)^2 * _internal_integral2_cos_square(pol, phi, pulse_len)

    return value_I21 + value_I22
end

# interface

@inline function _internal_integrals(pulse::CosSquarePulse, pol::P, method::Analytical, phi::T) where {T <: Number, P <: AbstractDefinitePolarization}

    pulse_len = pulse_length(pulse)
    value_I1 = _internal_integral1_cos_square(pol, phi, pulse_len)
    value_I2 = _internal_integral2_cos_square(pol, phi, pulse_len)

    return InternalIntegrals(
        InternalIntegralResult(value_I1, zero(value_I1)),
        InternalIntegralResult(value_I2, zero(value_I2))
    )
end

@inline function _internal_integrals(pulse::CosSquarePulse, pol::P, method::Analytical, phi::T) where {T <: Number, P <: AbstractIndefinitePolarization}
    pulse_len = pulse_length(pulse)
    value_I11 = oscillator(PolX(), pol.xi) * _internal_integral1_cos_square(PolX(), phi, pulse_len)
    value_I12 = oscillator(PolY(), pol.xi) * _internal_integral2_cos_square(PolY(), phi, pulse_len)

    value_I2 = _internal_integral2_cos_square(phi, pulse_len, pol.xi)

    return InternalIntegrals(res12, res12, res2)
end

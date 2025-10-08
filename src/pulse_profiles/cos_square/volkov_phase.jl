# correct for -dphi<=x<=dphi
@inline function _integral11_cos_square(x, dphi)
    return dphi / 4.0 * (sin((pi / dphi - 1) * x) / (pi - dphi) + sin((pi / dphi + 1) * x) / (pi + dphi) + 2 * sin(x) / dphi)
end

# value for x=dphi
@inline function _integral11_cos_square(dphi)
    return pi^2 / 2 * sin(dphi) / (pi^2 - dphi^2)
end

#=
function InternalIntegral1(x, dphi)
    if x <= -dphi
        return -_integral11_cos_square(dphi)
    elseif x >= dphi
        return _integral11_cos_square(dphi)
    else
        return _integral11_cos_square(x, dphi)
    end
end
=#

function _internal_integral1(pulse::CosSquarePulse, pol::XPol, method::Analytical, phi::Real)
    res = _integral11_cos_square(phi, pulse_length(pulse))
    return res
end

function _internal_integral1(pulse::CosSquarePulse, pol::YPol, method::Analytical, phi::Real)
    res = _integral12_cos_square(phi, pulse_length(pulse))
    return res
end

function _internal_integral2(pulse::CosSquarePulse, pol::XPol, method::Analytical, phi::Real)
    res = _integral21_cos_square(phi, pulse_length(pulse))
    return res
end

function _internal_integral2(pulse::CosSquarePulse, pol::YPol, method::Analytical, phi::Real)
    res = _integral22_cos_square(phi, pulse_length(pulse))
    return res
end

# TODO: extent this to arbitrary polarizations
function _internal_integral2(pulse::CosSquarePulse, pol::AbstractDefinitePolarization, method::AbstractNumericalIntegrationMethod, phi::Real)
    tmp_func = t -> (envelope(t, dphi) * oscillator(pol, t))^2
    res = integrate(method, tmp_func, 0, phi)
    return res
end

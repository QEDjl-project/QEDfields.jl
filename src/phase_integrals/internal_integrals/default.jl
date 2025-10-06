### default implementation for pulsed fields

# TODO: extent this to arbitrary polarizations
function _internal_integral1(pulse::AbstractPulseProfile, pol::AbstractDefinitePolarization, method::AbstractNumericalIntegrationMethod, phi::Real)
    tmp_func = t -> envelope(t, dphi) * oscillator(pol, t)
    res = integrate(method, tmp_func, 0, phi)
    return res
end

# TODO: extent this to arbitrary polarizations
function _internal_integral2(pulse::AbstractPulseProfile, pol::AbstractDefinitePolarization, method::AbstractNumericalIntegrationMethod, phi::Real)
    tmp_func = t -> (envelope(t, dphi) * oscillator(pol, t))^2
    res = integrate(method, tmp_func, 0, phi)
    return res
end

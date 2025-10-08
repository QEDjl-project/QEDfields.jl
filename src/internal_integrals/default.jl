### default implementation for pulsed fields

# TODO: extent this to arbitrary polarizations
function _compute(
        integral::AbstractUnivariateInternalIntegral,
        pulse::AbstractPulseProfile,
        pol::AbstractPolarization,
        phi::Real
    )

    tmp_func = t -> _envelope(pulse, t) * oscillator(pol, t)
    res = integrate(integration_method(integral), tmp_func, 0, phi)
    return res
end

# TODO: extent this to arbitrary polarizations
function _compute(
        integral::AbstractBivariateInternalIntegral,
        pulse::AbstractPulseProfile,
        pol::AbstractPolarization,
        phi::Real
    )

    tmp_func = t -> (_envelope(pulse, t) * oscillator(pol, t))^2
    res = integrate(integration_method(integral), tmp_func, 0, phi)
    return res
end

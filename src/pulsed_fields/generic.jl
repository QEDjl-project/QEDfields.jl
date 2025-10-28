# TODO:
# - extent the implementation to arbitrary polarization (be aware of the type parameter of
# AbstractBackgroundField)

### generic implementations for pulsed plane wave fields

# delegations
domain(field::AbstractPulsedPlaneWaveField) = domain(pulse_profile(field))
_envelope(field::AbstractPulsedPlaneWaveField, phi::Real) = _envelope(pulse_profile(field), phi)
envelope(field::AbstractPulsedPlaneWaveField, phi::Real) = envelope(pulse_profile(field), phi)
pulse_length(field::AbstractPulsedPlaneWaveField) = pulse_length(pulse_profile(field))


# amplitude functions

function _amplitude(
        field::AbstractPulsedPlaneWaveField{P}, phi::Real
    ) where {P <: AbstractDefinitePolarization}
    return oscillator(field, phi) * _envelope(field, phi)
end


# generic spectrum

# TODO: consider moving this to phase integrals and using the IntegralMethod interface

@inline function _fourier_transform(func::Function, domain::Interval, l::Real)
    return quadgk(t -> func(t) * exp(1im * t * l), endpoints(domain)...)[1]
end

"""

    generic_spectrum(field::AbstractPulsedPlaneWaveField, pol::AbstractDefinitePolarization, pnum)

Return the generic spectrum of the given field, for the given polarization direction `pol` and a given photon number parameter `pnum`.

!!! note "Convention"

    The generic spectrum is defined as the Fourier transform of the respective amplitude function for the given polarization direction:

    ```math
    \\begin{align*}
        x-\\mathrm{pol} &\\to \\int_{-\\infty}^{\\infty} g(\\phi) \\cos(\\phi) \\exp(il\\phi)\\\\
        y-\\mathrm{pol} &\\to \\int_{-\\infty}^{\\infty} g(\\phi) \\sin(\\phi) \\exp(il\\phi)
    \\end{align*}
    ```
    where ``g(\\phi)`` is the [`envelope`](@ref) and ``l`` the photon number parameter.
"""
function generic_spectrum(
        field::AbstractPulsedPlaneWaveField, pnum::Real
    )
    return _fourier_transform(t -> _amplitude(field, t), domain(field), pnum)
end

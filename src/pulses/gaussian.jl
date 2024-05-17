############################
# Gaussian pulsed plane wave
############################

"""
    GaussianPulse(mom::M,pulse_length::T) where {M<:QEDbase.AbstractFourMomentum,T<:Real}

Concrete implementation of an `AbstractPulsedPlaneWaveField` for Gaussian pulses.

Propagates along the direction given by the space-like components of the reference momentum vector k_mu = (omega/speed_of_light, k_x, k_y, k_z), and omega = 2*pi*speed_of_light/wavelength.

The time-like coordinate omega/speed_of_ligth of k_mu defines the field's oscillation frequency.

In order to fulfill the vacuum dispersion relation, k_mu*k^mu=0 is required.

!!! note "Pulse shape"

    The longitudinal envelope of a Gaussian pulse is defined as

    ```math
    g(\\phi) = \\exp(-\\frac{\\phi^2}{2\\Delta\\phi^2})
    ```
    for \$\\phi\\in (-\\infty, \\infty) and \$\\Delta\\phi`\$ denotes the `pulse_length`.

    There is no envelope in the transverse directions.

"""
struct GaussianPulse{M<:QEDbase.AbstractFourMomentum,T<:Real} <:
       AbstractPulsedPlaneWaveField
    mom::M
    pulse_length::T
end

"""

    _unsafe_gaussian_envelope(phi::Real, dphi::Real)

The envelope of the Gaussian background field is defined according to the standard Gaussian distribution with `dphi` representing the distribution's standard deviation.
"""
@inline function _unsafe_gaussian_envelope(phi, dphi)
    return exp(-0.5 * (phi / dphi)^2)
end

####
# interface functions
####

reference_momentum(pulse::GaussianPulse) = pulse.mom

function domain(pulse::GaussianPulse)
    dphi = pulse.pulse_length
    return Interval(-Inf, Inf)
end

pulse_length(pulse::GaussianPulse) = pulse.pulse_length

function _envelope(pulse::GaussianPulse, phi::Real)
    return _unsafe_gaussian_envelope(phi, pulse.pulse_length)
end

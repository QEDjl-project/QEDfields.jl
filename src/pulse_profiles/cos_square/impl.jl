"""

    CosSquarePulse(mom::M,pulse_length::T) where {M<:QEDbase.AbstractFourMomentum,T<:Real}

Concrete implementation of an `AbstractPulsedPlaneWaveField` for cos-square pulses.

!!! note "Pulse shape"

    The pulse envelope of a cos-square pulse is defined as

    ```math
    g(\\phi) = \\cos^2(\\frac{\\pi\\phi}{2\\Delta\\phi})
    ```
    for \$\\phi\\in (-\\Delta\\phi,\\Delta\\phi)\$, where \$\\Delta\\phi\$ denotes the `pulse_length`, and zero otherwise.

"""
struct CosSquarePulse{T <: Real} <: AbstractPulseProfile
    pulse_length::T
end

@inline function _unsafe_cos_square_envelope(phi, dphi)
    return cos(pi * phi / (2 * dphi))^2
end

####
# interface functions
####

function domain(pulse::CosSquarePulse)
    delta_phi = pulse.pulse_length
    return Interval(-delta_phi, delta_phi)
end

pulse_length(pulse::CosSquarePulse) = pulse.pulse_length

function _envelope(pulse::CosSquarePulse, phi::Real)
    return _unsafe_cos_square_envelope(phi, pulse.pulse_length)
end

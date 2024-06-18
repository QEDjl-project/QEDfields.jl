#####################
# Cosine square pulse
#####################

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
struct CosSquarePulse{M<:QEDbase.AbstractFourMomentum,T<:Real} <:
       AbstractPulsedPlaneWaveField
    mom::M
    pulse_length::T
end

@inline function _unsafe_cos_square_envelope(phi, dphi)
    return cos(pi * phi / (2 * dphi))^2
end

####
# interface functions
####

reference_momentum(pulse::CosSquarePulse) = pulse.mom

function domain(pulse::CosSquarePulse)
    delta_phi = pulse.pulse_length
    return Interval(-delta_phi, delta_phi)
end

pulse_length(pulse::CosSquarePulse) = pulse.pulse_length

function _envelope(pulse::CosSquarePulse, phi::Real)
    return _unsafe_cos_square_envelope(phi, pulse.pulse_length)
end

#######
# Special implementation for the generic spectrum
#######

@inline function _gsinc(x::T) where {T<:Real}
    return abs(x) == 1 ? one(x) / 2 : sinc(x) / (1 - x^2)
end

@inline function _generic_FT(l::Real, sig::Real)
    return sig * _gsinc(sig * l / pi)
end

function generic_spectrum(field::CosSquarePulse, pol::PolX, pnum::Real)
    dphi = field.pulse_length
    return 0.5 * (_generic_FT(pnum + 1, dphi) + _generic_FT(pnum - 1, dphi))
end

function generic_spectrum(field::CosSquarePulse, pol::PolY, pnum::Real)
    dphi = field.pulse_length
    return -0.5im * (_generic_FT(pnum + 1, dphi) - _generic_FT(pnum - 1, dphi))
end

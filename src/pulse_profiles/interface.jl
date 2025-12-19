"""

    AbstractPulseProfile

Abstract base type for pulse profiles.

## Interface functions:

- `domain(::AbstractPulseProfile)::AbstractInterval`
- `pulse_length(::AbstractPulseProfile)::Real`
- `_envelope(::AbstractPulseProfile,phi::Real)::Real`

"""
abstract type AbstractPulseProfile end
Base.broadcastable(p::AbstractPulseProfile) = Ref(p)

"""

    domain(::AbstractPulseProfile)

"""
function domain end

"""

    pulse_length(::AbstractPulseProfile)

"""
function pulse_length end

"""

    _envelope(::AbstractPulseProfile, phi::Real)

Return value of the envelope without bound-check.
"""
function _envelope end


"""

    envelope(pulsed_field::AbstractPulsedPlaneWaveField, phi::Real)

Return value of the envelope with bound-check.
"""
function envelope(field::AbstractPulseProfile, phi::Number)
    return phi in domain(field) ? _envelope(field, phi) : zero(phi)
end

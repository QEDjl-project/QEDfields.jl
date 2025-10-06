"""

    AbstractPulseProfile

Abstract base type for pulse profiles.

## Interface functions:

### Field interface (mandatory)

- `domain(::AbstractPulseProfile)::AbstractInterval`
- `pulse_length(::AbstractPulseProfile)::Real`
- `_envelope(::AbstractPulseProfile,phi::Real)::Real`

### Phase integral interface (optional)

```Julia
_internal_integral1(
    pulse::AbstractPulseProfile,
    pol::AbstractPolarization,
    method::AbstractIntegrationMethod,
    ::Real)

_internal_integral2(
    pulse::AbstractPulseProfile,
    pol::AbstractPolarization,
    method::AbstractIntegrationMethod,
    ::Real)
```
"""
abstract type AbstractPulseProfile end

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
function envelope(field::AbstractPulseProfile, phi::Real)
    return phi in domain(field) ? _envelope(field, phi) : zero(phi)
end

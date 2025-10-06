# interface for pulsed plane-wave fields


"""
Abstract base type for pulsed plane-wave fields.

Interface functions (from `AbstractPlaneWaveField`):
- `reference_momentum(::AbstractBackgroundField)::AbstractFourMomentum`
- `classical_nonlinearity_parameter(::AbstractBackgroundField)::Real`
- `polarization(::AbstractBackgroundField)::AbstractPolarization`

Additional interface functions:

- `pulse_profile(::AbstractPulsedPlaneWaveField)::AbstractPulseProfile`
"""
abstract type AbstractPulsedPlaneWaveField <: AbstractPlaneWaveField end

"""

    pulse_profile(field::AbstractPulsedPlaneWaveField)

Return subtype of `AbstractPulseProfile`.
"""
function pulse_profile end

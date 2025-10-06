### Interface for plane-wave fields

"""
Abstract base type for describing classical background fields.

Currently, only plane-wave fields are supported.

"""
abstract type AbstractBackgroundField end


### plane-wave fields

"""

    AbstractPlaneWaveField

Abstract base type for plane-wave fields.

Interface functions:

- `reference_momentum(::AbstractBackgroundField)::AbstractFourMomentum`
- `classical_nonlinearity_parameter(::AbstractBackgroundField)::Real`
- `polarization(::AbstractBackgroundField)::AbstractPolarization`
"""
abstract type AbstractPlaneWaveField <: AbstractBackgroundField end

"""

    reference_momentum(::AbstractPlaneWaveField)

Return a reference momentum indicating the direction the field is propagating.
"""
function reference_momentum end

"""

    classical_nonlinearity_parameter(::AbstractPlaneWaveField)

"""
function classical_nonlinearity_parameter end
const a0_parameter = classical_nonlinearity_parameter

function maximum_amplitude(field::AbstractPlaneWaveField)
    return a0_parameter(field) / ELEMENTARY_CHARGE
end

"""

    polarization(::AbstractPlaneWaveField)

Return type of polarization for the given field.
"""
function polarization end

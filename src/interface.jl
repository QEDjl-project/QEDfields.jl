### Interface for plane-wave fields

"""
Abstract base type for describing classical background fields.

Currently, only plane-wave fields are supported.

"""
abstract type AbstractBackgroundField{P <: AbstractPolarization} end
polarization(::AbstractBackgroundField{P}) where {P} = P

### plane-wave fields

"""

    AbstractPlaneWaveField

Abstract base type for plane-wave fields.

Interface functions:

- `reference_momentum(::AbstractBackgroundField)::AbstractFourMomentum`
- `classical_nonlinearity_parameter(::AbstractBackgroundField)::Real`
- `polarization(::AbstractBackgroundField)::AbstractPolarization`
"""
abstract type AbstractPlaneWaveField{P} <: AbstractBackgroundField{P} end

"""

    _amplitude(::AbstractPlaneWaveField, phi)

Interface function for background fields. Returns the value of the amplitude at a given point `phi`.
"""
function _amplitude end

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

# assumes unit system with m_e = 1.0 (all energy dims in units of the electron mass)
function maximum_amplitude(field::AbstractPlaneWaveField)
    return a0_parameter(field) / ELEMENTARY_CHARGE
end


"""

    _internal_integrals(::AbstractBackgroundField)

Returns the tuple of internal integrals: (I1, I2) for linear polarization, and (I11,I12,I2) for elliptic polarization
"""
function _internal_integrals end

"""

    _volkov_phase(
        ::AbstractBackgroundField,
        ::IntegrationMethod,
        phi::Real,
        beta1::Real,
        beta2::Real
    )


"""
function _volkov_phase end

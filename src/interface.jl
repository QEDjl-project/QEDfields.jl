### Interface for plane-wave fields

"""
Abstract base type for describing classical background fields.

Currently, only plane-wave fields are supported.

Interface funcitons:

- `polarization(::AbstractBackgroundField)::AbstractPolarization`

"""
abstract type AbstractBackgroundField{P <: AbstractPolarization} end
Base.broadcastable(field::AbstractBackgroundField) = Ref(field)
polarization_type(::AbstractBackgroundField{P}) where {P} = P

"""

    polarization(field::AbstractBackgroundField)

Interface function for general background fields. Return object which is subtype of `AbstractPolarization`.
"""
function polarization end

### plane-wave fields

"""

    AbstractPlaneWaveField

Abstract base type for plane-wave fields.

Interface functions:

- `_amplitude(::AbstractPlaneWaveField, ::AbstractDefinitePolarization, ::Real)`
- `_domain(field::AbstractPlaneWaveField)`
- `reference_momentum(::AbstractBackgroundField)::AbstractFourMomentum`
- `classical_nonlinearity_parameter(::AbstractBackgroundField)::Real`
- `polarization(::AbstractBackgroundField)::AbstractPolarization`

!!! note "Definition: plane-wave fields"

    Plane-wave fields are an idealization of electromagnetic fields from sources
    infinitely far away. Mathematically, a field is referred to as plane-wave, if **any** of
    the following equivalent points is fulfilled:
    * the field only depends on \$\\phi=k\\cdot x = \\omega t - \\vec k \\vec x\$ (mostly minus metric),
    * points with \$\\vec k \\vec x = \\mathrm{const.}\$ form parallel planes perpendicular to \$\\vec k\$,
    * the field invariants vanish, i.e. \$F^{\\mu\\nu}F_{\\mu\\nu} = 0\$, \$\\epsilon_{\\mu\\nu\\tau\\lambda}F^{\\mu\\nu}F^{\\tau\\lambda}=0\$.
"""
abstract type AbstractPlaneWaveField{P} <: AbstractBackgroundField{P} end

"""

    _amplitude(::AbstractPlaneWaveField, pol::AbstractDefinitePolarization, phi)

Interface function for background fields. Returns the value of the amplitude at a given point `phi`.
"""
function _amplitude end

#TODO: consider moving to generics
# - OR consider making this the actual interface function, because the three-args version
# is never called.
@inline function _amplitude(field::AbstractPlaneWaveField{P}, phi::Real) where {P <: AbstractDefinitePolarization}
    return _amplitude(field, polarization(field), phi)
end

"""

    domain(field::AbstractPlaneWaveField)

Interface function for plane-wave background fields. Return the domain of the field, i.e. the intervall, where the field has non-zero values.
"""
function domain end

#TODO: consider moving to generics
@inline compact_domain(field::AbstractPlaneWaveField) = domain(field)

"""

    reference_momentum(::AbstractPlaneWaveField)

Interface function for plane-wave background fields. Return a reference momentum indicating the direction the field is propagating.
"""
function reference_momentum end

"""

    classical_nonlinearity_parameter(::AbstractPlaneWaveField)

Interface function for plane-wave background fields. Return the classical nonlinearity parameter.
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

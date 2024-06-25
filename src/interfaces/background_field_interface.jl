####################
# The abstract background field interface
#
# In this file, the abstract interface for different types of background fields
# is defined. 
####################
"""
Abstract base type for describing classical background fields.

The only supported class of background fields yet, is the pulsed plane-wave field (see [`AbstractPulsedPlaneWaveField`](@ref) for details).
"""
abstract type AbstractBackgroundField end

#####
# pulsed plane-wave fields
#####

"""
Abstract base type for pulsed plane-wave fields.

!!! note "Pulsed field interface"

    For every subtype, the following functions need to be implemented.

    ```Julia

    reference_momentum(::AbstractPulsedPlaneWaveField)
    domain(::AbstractPulsedPlaneWaveField)
    pulse_length(::AbstractPulsedPlaneWaveField)
    envelope(::AbstractPulsedPlaneWaveField,x::Real)
    ```

"""
abstract type AbstractPulsedPlaneWaveField <: AbstractBackgroundField end

"""

    reference_momentum(::AbstractPulsedPlaneWaveField)

Interface function for [`AbstractPulsedPlaneWaveField`](@ref), which returns the reference momentum (as a subtype of `QEDbase.AbstractFourMomentum`) associated with the passed background field.
"""
function reference_momentum end

"""

    domain(::AbstractPulsedPlaneWaveField)

Interface function for [`AbstractPulsedPlaneWaveField`](@ref), which returns interval (as a `IntervalSets.Interval`) for the given background field. 

"""
function domain end

"""
    
    pulse_length(::AbstractPulsedPlaneWaveField)

Interface function for [`AbstractPulsedPlaneWaveField`](@ref), which returns a dimensionless representative number for the duration of the background field,
i.e. a half-width or standard deviation in units of phase periods.
"""
function pulse_length end

"""

    _envelope(::AbstractPulsedPlaneWaveField, phi::Real)

Interface function for [`AbstractPulsedPlaneWaveField`](@ref), which returns the value of the phase envelope function (also referred to as pulse envelope) for a given phase variable.

!!! note "Single point implementation"

    The interface function can be implemented for just one phase point as input. With that, evaluation on a vector of inputs is generically implemented by broadcasting.
    However, if there is a better custom implementation for vectors in input values, consider implementing 
    ```Julia
    
        _envelope(::AbstractPulsedPlaneWaveField, phi::AbstractVector{T<:Real})

    ```

!!! note "unsafe implementation"
    
    This is the unsafe version of the phase envelope function, i.e. this should be implement without input checks like the domain check. 
    In the safe version [`envelope`](@ref), a domain check is performed, i.e. it returns the value of `_envelope` if the passed in `phi` 
    is in the `domain` of the field, and zero otherwise. 

"""
function _envelope end

function _envelope(
    field::AbstractPulsedPlaneWaveField, phi::AbstractVector{T}
) where {T<:Real}
    # TODO: maybe use broadcasting here 
    return map(x -> _envelope(field, x), phi)
end

"""
    
    envelope(pulsed_field::AbstractPulsedPlaneWaveField, phi::Real)
    
Return the value of the phase envelope function (also referred to as pulse envelope or pulse shape) 
for given `pulsed_field` and phase `phi`. Performs domain check on `phi` before calling [`_envelope`](@ref); 
returns zero if `phi` is not in the domain returned by `[domain](@ref)`.
"""
function envelope(field::AbstractPulsedPlaneWaveField, phi::Real)
    return phi in domain(field) ? _envelope(field, phi) : zero(phi)
end

function envelope(
    field::AbstractPulsedPlaneWaveField, phi::AbstractVector{T}
) where {T<:Real}
    # TODO: maybe use broadcasting here 
    return map(x -> envelope(field, x), phi)
end

# amplitude functions

function _amplitude(
    field::AbstractPulsedPlaneWaveField, pol::AbstractDefinitePolarization, phi::Real
)
    return oscillator(pol, phi) * _envelope(field, phi)
end

function _amplitude(
    field::AbstractPulsedPlaneWaveField,
    pol::AbstractDefinitePolarization,
    phi::AbstractVector{T},
) where {T<:Real}
    # TODO: maybe use broadcasting here 
    return map(x -> _amplitude(field, pol, x), phi)
end

"""

    amplitude(field::AbstractPulsedPlaneWaveField, pol::AbstractDefinitePolarization, phi)

Returns the value of the amplitude for a given polarization direction and phase variable `phi`. 

!!! note "Conventions"

    There are two directions supported:

    ```Julia
    pol::PolX # -> return envelope(phi)*cos(phi)
    pol::PolY # -> return envelope(phi)*sin(phi)
    ```

!!! note "Safe implementation"
    
    In this function, a domain check is performed, i.e. if `phi` is in the domain of the field,
    the value of the amplitude is returned, and zero otherwise.
"""
function amplitude(
    field::AbstractPulsedPlaneWaveField, pol::AbstractDefinitePolarization, phi::Real
)
    return phi in domain(field) ? _amplitude(field, pol, phi) : zero(phi)
end

function amplitude(
    field::AbstractPulsedPlaneWaveField,
    pol::AbstractDefinitePolarization,
    phi::AbstractVector{T},
) where {T<:Real}
    # TODO: maybe use broadcasting here 
    return map(x -> amplitude(field, pol, x), phi)
end

# generic spectrum

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
    field::AbstractPulsedPlaneWaveField, pol::AbstractDefinitePolarization, pnum::Real
)
    return _fourier_transform(t -> _amplitude(field, pol, t), domain(field), pnum)
end

function generic_spectrum(
    field::AbstractPulsedPlaneWaveField,
    pol::AbstractDefinitePolarization,
    photon_number_parameter::AbstractVector{T},
) where {T<:Real}
    # TODO: maybe use broadcasting here 
    return map(x -> generic_spectrum(field, pol, x), photon_number_parameter)
end

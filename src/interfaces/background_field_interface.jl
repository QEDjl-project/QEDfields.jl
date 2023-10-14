####################
# The abstract background field interface
#
# In this file, the abstract interfaces for different types of background fields
# is defined. 
####################
"""
Abstract base type for describing classical background fields in general.

The only supported class of background fields yet, are the pulsed plane-wave field (see [`AbstractPulsedPlaneWaveField`](@ref) for details).
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
    phase_duration(::AbstractPulsedPlaneWaveField)
    pulse_envelope(::AbstractPulsedPlaneWaveField,x::Real)
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
    
    phase_duration(::AbstractPulsedPlaneWaveField)

Interface function for [`AbstractPulsedPlaneWaveField`](@ref), which returns the phase extent of the background field.
"""
function phase_duration end

"""

    _pulse_envelope(::AbstractPulsedPlaneWaveField, phi::Real)

Interface function for [`AbstractPulsedPlaneWaveField`](@ref), which returns the value of the pulse envelope function for a given phase variable.

!!! note "Single point implementation"

    The interface function can be implemented for just one phase point as input. With that, evaluation on a vector of inputs is generically implemented by broadcasting.
    However, if there is a better custom implementation for vectors in input values, consider implementing 
    ```Julia
    
        _pulse_envelope(::AbstractPulsedPlaneWaveField, phi::AbstractVector{T<:Real})

    ```

!!! note "unsafe implementation"
    
    This is the unsafe version of the pulse envelope function, i.e. this should be implement without input checks like the domain check. 
    In the safe version [`pulse_envelope`](@ref), a domain check is performed, i.e. it returns the value of `_pulse_envelope` if the passed in `phi` 
    is in the `domain` of the field, and zero otherwise. 

"""
function _pulse_envelope end

function _pulse_envelope(field::AbstractPulsedPlaneWaveField, phi::AbstractVector{T}) where T<:Real
    # TODO: maybe use broadcasting here 
    map(x->_pulse_envelope(field,x),phi)
end

"""
    
    pulse_envelope(::AbstractPulsedPlaneWaveField, phi::Real)
    
Pulse envelope funtion. Performs domain check on `phi` before calling [`_pulse_envelope`](@ref); returns zero if `phi` is not in the domain.
"""
function pulse_envelope(field::AbstractPulsedPlaneWaveField, phi::Real)
    phi in domain(field) ? _pulse_envelope(field,phi) : zero(phi)
end

function pulse_envelope(field::AbstractPulsedPlaneWaveField, phi::AbstractVector{T}) where T<:Real
    # TODO: maybe use broadcasting here 
    map(x->pulse_envelope(field,x),phi)
end

# amplitude functions

function _amplitude(field::AbstractPulsedPlaneWaveField, pol::AbstractDefinitePolarization,  phi::Real)
    return _oscillator(pol,phi)*_pulse_envelope(field,phi)
end

function _amplitude(field::AbstractPulsedPlaneWaveField, pol::AbstractDefinitePolarization, phi::AbstractVector{T}) where T<:Real
    # TODO: maybe use broadcasting here 
    return map(x->_amplitude(field,pol,x), phi)
end

"""

    amplitude(field::AbstractPulsedPlaneWaveField, pol::AbstractDefinitePolarization, phi)

Returns the value of the field amplitude for a given polarization direction and phase variable `phi`. 

!!! note "Conventions"

    There are two directions supported:

    ```Julia
    pol::PolX # -> return pulse_envelope(phi)*cos(phi)
    pol::PolY # -> return pulse_envelope(phi)*sin(phi)
    ```

!!! note "Safe implementation"
    
    In this function, a domain check is performed, i.e. if `phi` is in the domain of the field, the value of the amplitude is returned, and zero otherwise.
"""
function amplitude(field::AbstractPulsedPlaneWaveField, pol::AbstractDefinitePolarization, phi::Real)
    phi in domain(field) ? _amplitude(field,pol,phi) : zero(phi)
end

function amplitude(field::AbstractPulsedPlaneWaveField, pol::AbstractDefinitePolarization, phi::AbstractVector{T}) where T<:Real
    # TODO: maybe use broadcasting here 
    map(x->amplitude(field,pol,x),phi)
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
    x-\\mathrm{pol} \\to \\int_{-\\infty}^{\\infty} g(\\phi) \\cos(\\phi) \\exp{il\\phi}
    y-\\mathrm{pol} \\to \\int_{-\\infty}^{\\infty} g(\\phi) \\sin(\\phi) \\exp{il\\phi}
    ```
    # where ``g(\\phi)`` is the [`pulse_envelope`](@ref) and ``l`` the photon number parameter.
"""
function generic_spectrum(field::AbstractPulsedPlaneWaveField,pol::AbstractDefinitePolarization, pnum::Real)
    return _fourier_transform(t->amplitude(field, pol,t), domain(field), pnum)
end

function generic_spectrum(field::AbstractPulsedPlaneWaveField,pol::AbstractDefinitePolarization, photon_number_parameter::AbstractVector{T}) where T<:Real
    # TODO: maybe use broadcasting here 
    map(x->generic_spectrum(field, pol,x), photon_number_parameter)
end


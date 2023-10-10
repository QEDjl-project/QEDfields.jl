####################
# The abstract background field interface
#
# In this file, the abstract interfaces for different types of background fields
# is defined. 
####################

abstract type AbstractBackgroundField end

#####
# pulsed plane-wave fields
#####


"""
Abstract base type for pulsed plane-wave fields.

!!! note "Pulsed field interface"

For every subtype, the following functions need to be implemented.

    ```Julia

    reference_momentum(::AbstractBackgroundField)
    domain(::AbstractPulsedPlaneWaveField)
    pulse_width(::AbstractBackgroundField)
    pulse_envelope(::AbstractBackgroundField,x::Real)

    ```

"""
abstract type AbstractPulsedPlaneWaveField <: AbstractBackgroundField end


function reference_momentum end

"""
    domain(::AbstractPulsedPlaneWaveField)

Return domain for the given BG field. 

"""
function domain end

"""
    
    phase_duration(::AbstractPulsedPlaneWaveField) -> Float64

"""
function phase_duration end

"""

    _pulse_envelope(::AbstractPulsedPlaneWaveField, x::Real)

Unsafe version of the pulse envelope function. Implement this function without domain check. 

"""
function _pulse_envelope end

function _pulse_envelope(field::AbstractPulsedPlaneWaveField, phi::AbstractVector{T}) where T<:Real
    map(x->_pulse_envelope(field,x),phi)
end

"""
    
    pulse_envelope(::AbstractPulsedPlaneWaveField, x::Real)
    
Pulse envelope funtion. Performs domain check on `x` before calling [`_pulse_envelope`](@ref); returns zero if `x` is not in the domain.
"""
function pulse_envelope(field::AbstractPulsedPlaneWaveField, phi::Real)
    phi in domain(field) ? _pulse_envelope(field,phi) : zero(phi)
end

function pulse_envelope(field::AbstractPulsedPlaneWaveField, phi::AbstractVector{T}) where T<:Real
    map(x->pulse_envelope(field,x),phi)
end

# amplitude functions

function _amplitude(field::AbstractPulsedPlaneWaveField, pol::AbstractDefinitePolarization,  phi::Real)
    return _oscillator(pol,phi)*_pulse_envelope(phi)
end

function _amplitude(field::AbstractPulsedPlaneWaveField, pol::AbstractDefinitePolarization, phi::AbstractVector{T}) where T<:Real
    return map(x->_amplitude(field,pol,x), phi)
end

function amplitude(field::AbstractPulsedPlaneWaveField, pol::AbstractDefinitePolarization, phi::Real)
    phi in domain(field) ? _amplitude(field,phi) : zero(phi)
end

function amplitude(field::AbstractPulsedPlaneWaveField, pol::AbstractDefinitePolarization, phi::AbstractVector{T}) where T<:Real
    map(x->amplitude(field,pol,x),phi)
end

# generic spectrum
"""
    
    _fourier_transform(func::Function, domain::Interval, l::Real)

Generic implementation of the bounded Fourier transform of `func` at `l` in frequency space.

"""
@inline function _fourier_transform(func::Function, domain::Interval, l::Real)
    return quadgk(t -> func(t) * exp(1im * t * l), endpoints(domain)...)[1]
end

function generic_spectrum(field::AbstractPulsedPlaneWaveField,pol::AbstractDefinitePolarization, photon_number_parameter::Real)
    return _fourier_transform(t->amplitude(field, pol,t), domain(field), photon_number_parameter)
end

function generic_spectrum(field::AbstractPulsedPlaneWaveField,pol::AbstractDefinitePolarization, photon_number_parameter::AbstractVector{T}) where T<:Real
    map(x->generic_spectrum(field, pol,x), photon_number_parameter)
end


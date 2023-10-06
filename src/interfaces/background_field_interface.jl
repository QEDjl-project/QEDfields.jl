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

    domain(::AbstractPulsedPlaneWaveFields)
    pulse_width()
    pulse_envelope()

    ```

"""
abstract type AbstractPulsedPlaneWaveFields <: AbstractBackgroundField end

"""
    domain(::AbstractPulsedPlaneWaveFields)

Return domain for the given BG field. 

"""
function domain end

"""
    
    pulse_width(::AbstractPulsedPlaneWaveFields) -> Float64

"""
function pulse_width end

"""

    _pulse_envelope(::AbstractPulsedPlaneWaveFields, x::Real)

Unsafe version of the pulse envelope function. Implement this function without domain check. 

"""
function _pulse_envelope end


"""
    
    pulse_envelope(::AbstractPulsedPlaneWaveFields, x::Real)
    
Pulse envelope funtion. Performs domain check on `x` before calling [`_pulse_envelope`](@ref); returns zero if `x` is not in the domain.
"""
function pulse_envelope(field::AbstractPulsedPlaneWaveFields, x)
    x in domain(field) ? _pulse_envelope(field,x) : zero(x)
end


function _amplitude(field::AbstractPulsedPlaneWaveFields, pol::AbstractDefinitePolarisation, x)
    return polarisation_vector(field, pol)*cos(x)*_pulse_envelope(x)
end


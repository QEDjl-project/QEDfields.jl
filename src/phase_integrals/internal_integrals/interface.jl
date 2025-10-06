### minimal interface for internal integrals

abstract type AbstractInternalIntegral end

"""

    integration_method(::AbstractInternalIntegral)::AbstractIntegrationMethod

"""
function integration_method end

"""

    background_field(::AbstractInternalIntegral)::AbstractBackgroundField

"""
function background_field end


### additional interface functions for pulse profiles
# TODO: mode this to pulse profiles

"""

    _internal_integral1(::AbstractPulseProfile,::AbstractPolarization,::AbstractIntegrationMethod,phi::Real)


Return first order internal integral I1 at phi. No boundchecks are performed.
"""
function _internal_integral1 end

"""

    _internal_integral2(::AbstractPulseProfile,::AbstractPolarization,::AbstractIntegrationMethod,phi::Real)


Return first order internal integral I2 at phi. No boundchecks are performed.
"""
function _internal_integral2 end

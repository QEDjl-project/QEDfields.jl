# TODO:
# - generalize for abstract fields and then specialize on pulsed fields
# - consider static implementations, so `_compute` can be used in a GPU thread
# - consider batched version, e.g., `_compute!`
#
### minimal interface for internal integrals

abstract type AbstractInternalIntegral end

"""

    integration_method(::AbstractInternalIntegral)::AbstractIntegrationMethod

"""
function integration_method end

"""

    _compute(::AbstractInternalIntegral,::AbstractPulseProfile,::AbstractPolarization,phi::Real)


Return internal integral at phi. No boundchecks are performed.
"""
function _compute end

# represents I1 -> default specialization of _compute
abstract type AbstractUnivariateInternalIntegral <: AbstractInternalIntegral end

# represents I2 -> default specialization of _compute
abstract type AbstractBivariateInternalIntegral <: AbstractInternalIntegral end

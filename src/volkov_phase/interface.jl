abstract type AbstractVolkovPhase end

"""

    _internal_integral1(::AbstractVolkovPhase)::AbstractUnivariateInternalIntegral

Return first order internal integral I1.
"""
function _internal_integral1 end

"""

    _internal_integral2(::AbstractVolkovPhase)::AbstractBivariateInternalIntegral

Return second order internal integral I2.
"""
function _internal_integral2 end

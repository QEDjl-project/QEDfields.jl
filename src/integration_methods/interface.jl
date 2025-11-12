# TODO: consider using `Integrals.jl` here


# inegration methods

abstract type AbstractIntegrationMethod end
Base.broadcastable(method::AbstractIntegrationMethod) = Ref(method)
abstract type AbstractAnalyticalMethod <: AbstractIntegrationMethod end
abstract type AbstractNumericalIntegrationMethod <: AbstractIntegrationMethod end

"""

    integrate(::AbstractNumericalIntegrationMethod,func,low,up)

Interface function for subtypes of `AbstractNumericalIntegrationMethod`.
"""
function integrate end

@inline function integrate(method::AbstractNumericalIntegrationMethod, func::Function, domain::AbstractInterval)
    return integrate(method, func, endpoints(domain)...)
end

abstract type AbstractQuadratureMethod <: AbstractNumericalIntegrationMethod end

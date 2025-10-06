# TODO:
# - consider extenting the interface for quadrature rules (e.g. order(::AbstractQuadratureMethod),...)

"""

    GaussLegendreQuadrature(order)

Integration method using Gauss-Legendre nodes provided by `FastGaussQuadrature.jl`
"""
struct GaussLegendreQuadrature{P, W} <: AbstractQuadratureMethod
    order::Int
    nodes::P
    weights::W

    function GaussLegendreQuadrature(order::Int)

        x, w = gausslegendre(order)
        return new{typeof(x), typeof(w)}(order, x, w)
    end
end

function quadrature_nodes(method::GaussLegendreQuadrature, low, high)
    slope = (high - low) / 2
    shift = (low + high) / 2
    return @. slope * method.nodes + shift
end

function quadrature_weights(method::GaussLegendreQuadrature, low, high)
    fac = (high - low) / 2
    return @. fac * method.weights
end

function integrate(meth::GaussLegendreQuadrature, func::Function, low::Real, high::Real)
    return LinearAlgebra.dot(
        quadrature_weights(meth, low, high),
        func.(quadrature_nodes(meth, low, high))
    )
end
